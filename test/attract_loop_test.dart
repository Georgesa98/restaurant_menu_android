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
import 'package:shared_preferences/shared_preferences.dart';

Future<(AppDb, SharedPreferences)> _harness() async {
  SharedPreferences.setMockInitialValues({'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final db = AppDb.forTesting(NativeDatabase.memory());
  addTearDown(db.close);
  return (db, prefs);
}

/// Wraps [child] in a ProviderScope. The overrides literal lives here so
/// its element type is inferred from the `overrides:` parameter (naming
/// `Override` directly would need a private riverpod import).
ProviderScope _scope(AppDb db, SharedPreferences prefs, Widget child) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDbProvider.overrideWithValue(db),
      secureStorageProvider.overrideWithValue(MemorySecureStore()),
      dbReadyProvider.overrideWith((ref) async {}),
      // path_provider has no test implementation: skip pinned brand files
      // so the provider resolves without touching the platform channel.
      attractBrandFilesProvider.overrideWith(
        (ref) async => (logo: null as File?, cover: null as File?),
      ),
    ],
    child: child,
  );
}

Future<void> _seedDemo(AppDb db) async {
  await db.into(db.tenants).insert(
        TenantsCompanion.insert(
          id: 'demo',
          name: 'Demo Restaurant',
          slug: 'demo',
          description: const Value('Fire-grilled favorites'),
          address: const Value('12 Main St'),
          phone: const Value('+963 11 000 000'),
        ),
      );
  await db.into(db.menuItems).insert(
        MenuItemsCompanion.insert(
          id: 'i1',
          tenantId: 'demo',
          categoryId: 'c1',
          name: 'Kofta',
          updatedAt: '2026-09-14T00:00:00.000Z',
          imageUrl: const Value('https://example.invalid/kofta.jpg'),
          basePrice: const Value(120),
        ),
      );
  await db.into(db.menuItems).insert(
        MenuItemsCompanion.insert(
          id: 'i2',
          tenantId: 'demo',
          categoryId: 'c1',
          name: 'Shish Tawook',
          updatedAt: '2026-09-14T00:00:00.000Z',
          imageUrl: const Value('https://example.invalid/tawook.jpg'),
          basePrice: const Value(140),
        ),
      );
}

class _PushHost extends StatelessWidget {
  const _PushHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AttractLoopOverlay(),
              fullscreenDialog: true,
            ),
          ),
          child: const Text('open'),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('empty kiosk shows brand frame with touch hint', (tester) async {
    final (db, prefs) = await _harness();

    await tester.pumpWidget(
      _scope(db, prefs, const MaterialApp(home: AttractLoopOverlay())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Demo Restaurant'), findsWidgets);
    expect(find.text('Touch to browse'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('hero shows brand name only, no dish grid', (tester) async {
    final (db, prefs) = await _harness();
    await _seedDemo(db);

    await tester.pumpWidget(
      _scope(db, prefs, const MaterialApp(home: AttractLoopOverlay())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Demo Restaurant'), findsOneWidget);
    expect(find.text('Touch to browse'), findsOneWidget);
    // Middle of the screen is typo-only: dishes, tagline, and contact stay
    // in the kiosk menu, not on the idle hero — even when items exist.
    expect(find.text('Kofta'), findsNothing);
    expect(find.text('Shish Tawook'), findsNothing);
    expect(find.text('SYP 120'), findsNothing);
    expect(find.text('SYP 140'), findsNothing);
    expect(find.text('Fire-grilled favorites'), findsNothing);
    expect(find.textContaining('12 Main St'), findsNothing);
  });

  testWidgets('tap dismisses the overlay and pops the route', (tester) async {
    final (db, prefs) = await _harness();
    await _seedDemo(db);

    await tester.pumpWidget(
      _scope(db, prefs, const MaterialApp(home: _PushHost())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Touch to browse'), findsOneWidget);

    await tester.tap(find.text('Touch to browse'));
    await tester.pumpAndSettle();
    expect(find.text('Touch to browse'), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });
}
