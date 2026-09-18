import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/api/api_client.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/core/i18n/locale_controller.dart';
import 'package:restaurant_menu_android/core/sync/heartbeat.dart';
import 'package:restaurant_menu_android/core/sync/sync_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sync_pull_test.dart' show stubDio, testClient;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HeartbeatResult', () {
    test('parses revision + flag', () {
      final r = HeartbeatResult.fromJson({'revision': 7, 'syncRequired': true});
      expect(r.revision, 7);
      expect(r.syncRequired, isTrue);
    });

    test('missing keys default to current', () {
      final r = HeartbeatResult.fromJson({});
      expect(r.revision, 0);
      expect(r.syncRequired, isFalse);
    });
  });

  group('tabletDeviceId', () {
    test('mints once and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final first = await tabletDeviceId(prefs);
      expect(first, isNotEmpty);
      expect(await tabletDeviceId(prefs), first);
      expect(prefs.getString('tablet_device_id'), first);
    });
  });

  group('revision storage', () {
    late AppDb db;

    setUp(() {
      db = AppDb.forTesting(NativeDatabase.memory());
    });

    tearDown(() => db.close());

    test('localRevision is 0 before the first pull', () async {
      expect(await localRevision(db, 'demo'), 0);
    });

    test('applyPull persists revision + poll flag', () async {
      final engine = SyncEngine(db, testClient(stubDio({})));
      await engine.applyPull(
        {
          'serverTime': '2026-09-18T10:00:00.000Z',
          'tenant': {
            'id': 'tenant-1',
            'name': 'Valley Star',
            'slug': 'demo',
            'revision': 9,
            'syncRequired': true,
          },
          'categories': [],
          'items': [],
        },
        replace: true,
      );
      final row =
          await (db.select(db.tenants)..where((t) => t.slug.equals('demo')))
              .getSingle();
      expect(row.revision, 9);
      expect(row.syncRequired, isTrue);
      expect(await localRevision(db, 'demo'), 9);
    });

    test('applyPull defaults revision on old servers', () async {
      final engine = SyncEngine(db, testClient(stubDio({})));
      await engine.applyPull(
        {
          'serverTime': '2026-09-18T10:00:00.000Z',
          'tenant': {'id': 'tenant-1', 'name': 'T', 'slug': 'demo'},
          'categories': [],
          'items': [],
        },
        replace: true,
      );
      final row =
          await (db.select(db.tenants)..where((t) => t.slug.equals('demo')))
              .getSingle();
      expect(row.revision, 0);
      expect(row.syncRequired, isFalse);
    });
  });

  group('sendHeartbeat', () {
    // sendHeartbeat takes a Ref: probe it through a throwaway provider.
    final probe = FutureProvider.autoDispose
        .family<HeartbeatResult?, int?>((ref, known) => sendHeartbeat(ref, knownRevision: known));

    test('posts slashed path with device + revision, parses reply', () async {
      SharedPreferences.setMockInitialValues({'locale': 'en'});
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tablet_device_id', 'device-1');

      Map<String, dynamic>? seenBody;
      String? seenPath;
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            seenPath = options.path;
            seenBody = Map<String, dynamic>.from(options.data as Map);
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'revision': 5, 'syncRequired': true},
              ),
            );
          },
        ),
      );

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(testClient(dio)),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(probe(4).future);
      expect(result, isNotNull);
      expect(result!.revision, 5);
      expect(result.syncRequired, isTrue);
      // Slashed const: avoids the server's trailingSlash 308 (see §21).
      expect(seenPath, heartbeatPath);
      expect(seenBody!['deviceId'], 'device-1');
      expect(seenBody!['knownRevision'], 4);
      expect(seenBody!['locale'], 'en');
      expect(seenBody!['slug'], isNotEmpty);
    });

    test('offline heartbeat returns null', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(testClient(stubDio({}))),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      expect(await container.read(probe(null).future), isNull);
    });
  });

  test('tenants seed explicit revision defaults', () async {
    final db = AppDb.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.into(db.tenants).insert(
          TenantsCompanion.insert(id: 't', name: 'T', slug: 'demo'),
        );
    final row =
        await (db.select(db.tenants)..where((t) => t.slug.equals('demo')))
            .getSingle();
    expect(row.revision, 0);
    expect(row.syncRequired, isFalse);
    expect(row.toString(), isNotNull);
    // Companion carries the new columns (drift v4, PLAN §31).
    const companion = TenantsCompanion(
      revision: Value(3),
      syncRequired: Value(true),
    );
    expect(companion.revision.value, 3);
    expect(companion.syncRequired.value, isTrue);
  });
}
