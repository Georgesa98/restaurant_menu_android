import 'package:dio/dio.dart';
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
}
