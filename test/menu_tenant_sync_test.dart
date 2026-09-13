import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/api/api_client.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/core/db/db_provider.dart';
import 'package:restaurant_menu_android/core/i18n/locale_controller.dart';
import 'package:restaurant_menu_android/core/sync/sync_engine.dart';
import 'package:restaurant_menu_android/features/menu/menu_tenant_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regression: pulls store rows under the server uuid, so kiosk queries must
/// follow the resolved id — before the fix they kept reading the baked id
/// and synced categories stayed invisible.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('pull with server uuid makes categories visible to kiosk queries',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDb.forTesting(NativeDatabase.memory());
    final store = MemorySecureStore();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDbProvider.overrideWithValue(db),
        secureStorageProvider.overrideWithValue(store),
        dbReadyProvider.overrideWith((ref) async {}),
      ],
    );
    addTearDown(() {
      container.dispose();
      db.close();
    });

    // Pre-pull: baked demo fallback.
    expect(container.read(menuTenantIdProvider), 'demo');

    final engine = SyncEngine(
      db,
      ApiClient(Dio(), store, tenantSlug: 'demo', bakedTenantId: ''),
      onTenantResolved: (id) async {
        await store.write(key: 'tenant_id', value: id);
        container.read(menuTenantIdProvider.notifier).adopt(id);
      },
    );
    await engine.applyPull(
      {
        'serverTime': '2026-09-13T00:00:00.000Z',
        'tenant': {'id': 'uuid-server', 'slug': 'demo', 'name': 'Demo'},
        'categories': [
          {
            'id': 'c1',
            'name': 'Grill',
            'slug': 'grill',
            'displayOrder': 0,
            'isActive': true,
            'translations': [],
          },
        ],
        'items': [
          {
            'id': 'i1',
            'categoryId': 'c1',
            'name': 'Kofta',
            'basePrice': 100,
            'isAvailable': true,
            'displayOrder': 0,
            'translations': [],
            'variants': [],
          },
        ],
      },
      replace: true,
    );

    // Resolved id adopted…
    expect(container.read(menuTenantIdProvider), 'uuid-server');
    expect(await store.read(key: 'tenant_id'), 'uuid-server');
    // …and kiosk queries through it see the pulled rows, while the stale
    // baked id sees nothing (the old failure mode).
    final tid = container.read(menuTenantIdProvider);
    expect((await db.visibleCategories(tid)).map((c) => c.name), ['Grill']);
    expect(await db.visibleCategories('demo'), isEmpty);
  });
}
