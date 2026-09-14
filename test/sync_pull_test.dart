import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/api/api_client.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/core/sync/sync_engine.dart';

/// Dio stub: maps "METHOD path" to canned JSON or a status error.
Dio stubDio(Map<String, Object> routes) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final key = '${options.method} ${options.path}';
        final route = routes[key];
        if (route is Map<String, dynamic>) {
          handler.resolve(
            Response(requestOptions: options, statusCode: 200, data: route),
          );
        } else if (route is int) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(requestOptions: options, statusCode: route),
              type: DioExceptionType.badResponse,
            ),
          );
        } else {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: 'no route',
            ),
          );
        }
      },
    ),
  );
  return dio;
}

Map<String, dynamic> pullPayload({String serverTime = '2026-09-08T01:00:00.000Z'}) => {
      'serverTime': serverTime,
      'tenant': {
        'id': 'tenant-1',
        'name': 'Valley Star',
        'slug': 'valley-star',
        'primaryColor': '#123456',
      },
      'categories': [
        {
          'id': 'c1',
          'name': 'مشاوي',
          'slug': 'grill',
          'displayOrder': 0,
          'isActive': true,
          'isDeleted': false,
          'updatedAt': serverTime,
          'translations': [
            {'locale': 'en', 'name': 'Grill', 'description': null},
          ],
        },
      ],
      'items': [
        {
          'id': 'i1',
          'categoryId': 'c1',
          'name': 'كفتة',
          'description': 'desc',
          'basePrice': '180.00',
          'imageUrl': null,
          'isAvailable': true,
          'displayOrder': 0,
          'dietaryTags': ['spicy'],
          'isDeleted': false,
          'updatedAt': serverTime,
          'translations': [
            {'locale': 'en', 'name': 'Kofta', 'description': 'desc en'},
          ],
          'variants': [
            {
              'id': 'v1',
              'label': 'نصف',
              'labelEn': 'Half',
              'price': '90.00',
              'sortOrder': 0,
            },
          ],
        },
      ],
    };

ApiClient testClient(Dio dio) => ApiClient(
      dio,
      MemorySecureStore(),
      tenantSlug: 'valley-star',
      bakedTenantId: '',
    );

void main() {
  late AppDb db;

  setUp(() {
    db = AppDb.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('full pull applies tenant, rows, children, cursor', () async {
    final engine = SyncEngine(db, testClient(stubDio({'GET /api/sync/pull': pullPayload()})));
    final outcome = await engine.pull(full: true);

    expect(outcome.status, SyncStatus.fullRepulled);
    expect(outcome.pulledCategories, 1);
    expect(outcome.pulledItems, 1);

    final tenant = await (db.select(db.tenants)).getSingle();
    expect(tenant.primaryColor, '#123456');

    final items = await db.visibleItems('c1');
    expect(items.single.name, 'كفتة');

    final trs = await (db.select(db.menuItemTranslations)).get();
    expect(trs.single.name, 'Kofta');

    final vars = await (db.select(db.menuItemVariants)).get();
    expect(vars.single.price, 90.0);

    final cursor = await (db.select(db.syncState)).getSingle();
    expect(cursor.lastPullAt, '2026-09-08T01:00:00.000Z');
  });

  test('delta pull sends since cursor', () async {
    var calls = 0;
    String? seenSince;
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          calls++;
          seenSince = options.queryParameters['since'] as String?;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: pullPayload(
                serverTime: calls == 1
                    ? '2026-09-08T01:00:00.000Z'
                    : '2026-09-08T02:00:00.000Z',
              ),
            ),
          );
        },
      ),
    );
    final engine = SyncEngine(db, testClient(dio));

    await engine.pull(full: true);
    expect(seenSince, isNull);

    await engine.pull();
    expect(seenSince, '2026-09-08T01:00:00.000Z');
  });

  test('tombstone deletes locally with cascade', () async {
    final engine = SyncEngine(db, testClient(stubDio({'GET /api/sync/pull': pullPayload()})));
    await engine.pull(full: true);
    expect(await db.visibleItems('c1'), hasLength(1));

    final tombstone = pullPayload(serverTime: '2026-09-08T03:00:00.000Z');
    // Server cascades the flag to items (mirrors DELETE /api/categories/:id).
    (tombstone['categories'] as List).single['isDeleted'] = true;
    (tombstone['items'] as List).single['isDeleted'] = true;
    final engine2 = SyncEngine(
      db,
      testClient(stubDio({'GET /api/sync/pull': tombstone})),
    );
    await engine2.pull();

    expect(await db.visibleItems('c1'), isEmpty);
    expect(await (db.select(db.categories)).get(), isEmpty);
    expect(await (db.select(db.menuItemVariants)).get(), isEmpty);
  });

  test('410 triggers one full re-pull', () async {
    var calls = 0;
    String? lastSince;
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          calls++;
          lastSince = options.queryParameters['since'] as String?;
          if (calls == 1) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: pullPayload(serverTime: '2026-09-08T01:00:00.000Z'),
              ),
            );
          } else if (lastSince != null) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(requestOptions: options, statusCode: 410),
                type: DioExceptionType.badResponse,
              ),
            );
          } else {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: pullPayload(serverTime: '2026-09-08T04:00:00.000Z'),
              ),
            );
          }
        },
      ),
    );
    final engine = SyncEngine(db, testClient(dio));
    await engine.pull(full: true);
    final outcome = await engine.pull();
    expect(outcome.status, SyncStatus.fullRepulled);
    expect(calls, 3);
    final cursor = await (db.select(db.syncState)).getSingle();
    expect(cursor.lastPullAt, '2026-09-08T04:00:00.000Z');
  });

  test('offline maps to offline status', () async {
    final engine = SyncEngine(db, testClient(stubDio({})));
    final outcome = await engine.pull(full: true);
    expect(outcome.status, SyncStatus.offline);
  });

  test('push expresses tombstoned variant ids and drops them on accept', () async {
    // Seed one dirty item with a live + a tombstoned variant.
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: 'c1',
            tenantId: 'tenant-1',
            name: 'Grill',
            slug: 'grill',
            updatedAt: '2026-09-08T00:00:00.000Z',
          ),
        );
    await db.into(db.menuItems).insert(
          MenuItemsCompanion.insert(
            id: 'i1',
            tenantId: 'tenant-1',
            categoryId: 'c1',
            name: 'كفتة',
            updatedAt: '2026-09-08T00:00:00.000Z',
            dirty: const Value(true),
          ),
        );
    for (final (id, deleted) in [('v1', false), ('v2', true)]) {
      await db.into(db.menuItemVariants).insert(
            MenuItemVariantsCompanion.insert(
              id: id,
              menuItemId: 'i1',
              label: 'x',
              price: 10,
              isDeleted: Value(deleted),
              dirty: const Value(true),
            ),
          );
    }
    Map<String, dynamic>? seenBody;
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          seenBody = Map<String, dynamic>.from(options.data as Map);
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'serverTime': '2026-09-08T05:00:00.000Z',
                'accepted': {
                  'categoryIds': <String>[],
                  'itemIds': ['i1'],
                },
                'conflicts': <String, dynamic>{},
              },
            ),
          );
        },
      ),
    );
    final outcome = await SyncEngine(db, testClient(dio)).push();

    expect(outcome.status, SyncStatus.ok);
    expect(outcome.pushed, 1);
    expect(
      (seenBody!['deletes'] as Map)['variantIds'],
      contains('v2'),
    );
    // Tombstone dropped, survivor kept clean.
    expect(
      await (db.select(db.menuItemVariants)
            ..where((v) => v.id.equals('v2')))
          .getSingleOrNull(),
      isNull,
    );
    final v1 = await (db.select(db.menuItemVariants)
          ..where((v) => v.id.equals('v1')))
        .getSingle();
    expect(v1.dirty, isFalse);
  });

  test('push applies server-wins conflict children wholesale', () async {
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: 'c1',
            tenantId: 'tenant-1',
            name: 'Local',
            slug: 'grill',
            updatedAt: '2026-09-08T00:00:00.000Z',
            dirty: const Value(true),
          ),
        );
    await db.into(db.categoryTranslations).insert(
          CategoryTranslationsCompanion.insert(
            categoryId: 'c1',
            locale: 'en',
            name: 'Local EN',
            dirty: const Value(true),
          ),
        );
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'serverTime': '2026-09-08T06:00:00.000Z',
                'accepted': <String, dynamic>{},
                'conflicts': {
                  'categories': [
                    {
                      'id': 'c1',
                      'tenantId': 'tenant-1',
                      'name': 'Server',
                      'slug': 'grill',
                      'updatedAt': '2026-09-08T06:00:00.000Z',
                      'translations': [
                        {'locale': 'en', 'name': 'Server EN'},
                      ],
                    },
                  ],
                  'items': <Map<String, dynamic>>[],
                },
              },
            ),
          );
        },
      ),
    );
    final outcome = await SyncEngine(db, testClient(dio)).push();

    expect(outcome.status, SyncStatus.ok);
    expect(outcome.conflicts, 1);
    final cat =
        await (db.select(db.categories)..where((c) => c.id.equals('c1')))
            .getSingle();
    expect(cat.name, 'Server');
    expect(cat.dirty, isFalse);
    final trs = await (db.select(db.categoryTranslations)).get();
    expect(trs.single.name, 'Server EN');
    expect(trs.single.dirty, isFalse);
  });
}
