import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/core/db/seed_tenant.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDb db;

  setUp(() {
    db = AppDb.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('demo asset seeds the full valley-star dataset', () async {
    await seedTenantFromAsset(
      db,
      assetPath: 'assets/seed/demo.json',
      tenantId: 'demo',
      slug: 'demo',
      name: 'Demo Restaurant',
    );

    final tenant = await (db.select(db.tenants)).getSingle();
    expect(tenant.slug, 'demo');
    expect(tenant.primaryColor, '#2E3B42');

    final cats = await (db.select(db.categories)).get();
    expect(cats.length, 13);

    final items = await (db.select(db.menuItems)).get();
    expect(items.length, 200);
    final catIds = cats.map((c) => c.id).toSet();
    for (final i in items) {
      expect(catIds, contains(i.categoryId));
      expect(i.dirty, isFalse);
    }

    final vars = await (db.select(db.menuItemVariants)).get();
    expect(vars.length, 52);
    for (final v in vars) {
      expect(v.price, greaterThan(0));
    }

    final enTrs = await (db.select(db.menuItemTranslations)
          ..where((t) => t.locale.equals('en')))
        .get();
    expect(enTrs.length, items.length);

    // Variant items carry no base price (web rule).
    final withVariants =
        vars.map((v) => v.menuItemId).toSet();
    for (final i in items.where((e) => withVariants.contains(e.id))) {
      expect(i.basePrice, isNull);
    }
  });

  test('missing asset surfaces a clear error', () async {
    await expectLater(
      seedTenantFromAsset(
        db,
        assetPath: 'assets/seed/does-not-exist.json',
        tenantId: 'demo',
        slug: 'demo',
        name: 'Demo',
      ),
      throwsA(isA<FlutterError>()),
    );
  });
}
