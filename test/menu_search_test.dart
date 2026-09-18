import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/api/api_client.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/core/db/db_provider.dart';
import 'package:restaurant_menu_android/core/i18n/locale_controller.dart';
import 'package:restaurant_menu_android/features/kiosk/attract_loop.dart';
import 'package:restaurant_menu_android/features/kiosk/screensaver_controller.dart';
import 'package:restaurant_menu_android/features/menu/menu_page.dart';
import 'package:restaurant_menu_android/features/menu/menu_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screensaver without the 3-min idle timer (a pending real Timer fails the
/// widget-test invariant even though the provider cancels it on dispose).
class _StillScreensaver extends Screensaver {
  @override
  bool build() => false;
}

Future<(AppDb, SharedPreferences)> _harness() async {
  SharedPreferences.setMockInitialValues({'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final db = AppDb.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  return (db, prefs);
}

ProviderScope _scope(AppDb db, SharedPreferences prefs, Widget child) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDbProvider.overrideWithValue(db),
      secureStorageProvider.overrideWithValue(MemorySecureStore()),
      dbReadyProvider.overrideWith((ref) async {}),
      screensaverProvider.overrideWith(_StillScreensaver.new),
      attractBrandFilesProvider.overrideWith(
        (ref) async => (logo: null as File?, cover: null as File?),
      ),
    ],
    child: child,
  );
}

Future<void> _seed(AppDb db) async {
  await db.into(db.tenants).insert(
        TenantsCompanion.insert(
          id: 'demo',
          name: 'Demo Restaurant',
          slug: 'demo',
        ),
      );
  await db.into(db.categories).insert(
        CategoriesCompanion.insert(
          id: 'c1',
          tenantId: 'demo',
          name: 'Grill',
          slug: 'grill',
          updatedAt: '2026-09-14T00:00:00.000Z',
        ),
      );
  await db.into(db.menuItems).insert(
        MenuItemsCompanion.insert(
          id: 'i1',
          tenantId: 'demo',
          categoryId: 'c1',
          name: 'Kofta',
          description: const Value('Charcoal-grilled'),
          basePrice: const Value(120),
          updatedAt: '2026-09-14T00:00:00.000Z',
        ),
      );
  await db.into(db.menuItems).insert(
        MenuItemsCompanion.insert(
          id: 'i2',
          tenantId: 'demo',
          categoryId: 'c1',
          name: 'Shish Tawook',
          basePrice: const Value(140),
          updatedAt: '2026-09-14T00:00:00.000Z',
        ),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('live pins sort before unpinned in category views', () async {
    final (db, prefs) = await _harness();
    await _seed(db);
    await db.into(db.menuItems).insert(
          MenuItemsCompanion.insert(
            id: 'i3',
            tenantId: 'demo',
            categoryId: 'c1',
            name: 'Pinned Dish',
            isFeatured: const Value(true),
            updatedAt: '2026-09-14T00:00:00.000Z',
          ),
        );
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDbProvider.overrideWithValue(db),
        secureStorageProvider.overrideWithValue(MemorySecureStore()),
        dbReadyProvider.overrideWith((ref) async {}),
      ],
    );
    addTearDown(container.dispose);
    final states = <List<MenuItemView>>[];
    container.listen(
      menuItemViewsProvider('c1'),
      (_, next) => states.add(next),
      fireImmediately: true,
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final full = states.lastWhere((s) => s.length == 3);
    expect(full.map((v) => v.item.id), ['i3', 'i1', 'i2']);
  });

  test('expired pins sort with the rest', () async {
    final (db, prefs) = await _harness();
    await _seed(db);
    await db.into(db.menuItems).insert(
          MenuItemsCompanion.insert(
            id: 'i3',
            tenantId: 'demo',
            categoryId: 'c1',
            name: 'Zulu Expired Pin',
            isFeatured: const Value(true),
            featuredUntil: const Value('2020-01-01T00:00:00.000Z'),
            updatedAt: '2026-09-14T00:00:00.000Z',
          ),
        );
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDbProvider.overrideWithValue(db),
        secureStorageProvider.overrideWithValue(MemorySecureStore()),
        dbReadyProvider.overrideWith((ref) async {}),
      ],
    );
    addTearDown(container.dispose);
    final states = <List<MenuItemView>>[];
    container.listen(
      menuItemViewsProvider('c1'),
      (_, next) => states.add(next),
      fireImmediately: true,
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final full = states.lastWhere((s) => s.length == 3);
    expect(full.map((v) => v.item.id), ['i1', 'i2', 'i3']);
  });

  testWidgets('typing filters home to matching dishes', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    final (db, prefs) = await _harness();
    await _seed(db);

    await tester.pumpWidget(
      _scope(db, prefs, const MaterialApp(home: MenuPage())),
    );
    // NB: plain pumps, not pumpAndSettle — the focused search field's
    // cursor blink never settles.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    // Landing shows the category before searching.
    expect(find.text('Grill'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'tawook');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Shish Tawook'), findsOneWidget);
    expect(find.text('Kofta'), findsNothing);
    expect(find.text('Grill'), findsNothing);

    // Unmount first: disposing drift stream subscriptions schedules a
    // zero-duration cleanup timer that would otherwise trip the
    // still-pending-timer invariant at teardown.
    await tester.pumpWidget(Container());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('no match shows the empty-results message', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    final (db, prefs) = await _harness();
    await _seed(db);

    await tester.pumpWidget(
      _scope(db, prefs, const MaterialApp(home: MenuPage())),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('No results for "zzz"'), findsOneWidget);

    await tester.pumpWidget(Container());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
