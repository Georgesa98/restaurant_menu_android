import 'package:drift/drift.dart';

import 'app_db.dart';

/// Demo content for dev builds (`TENANT_SLUG=demo`). Never shipped per-tenant.
Future<void> seedDemo(AppDb db) async {
  const now = '2026-09-08T00:00:00.000Z';
  await db.transaction(() async {
    await db.into(db.tenants).insert(
          TenantsCompanion.insert(
            id: 'demo',
            name: 'Demo Restaurant',
            slug: 'demo',
          ),
          mode: InsertMode.insertOrReplace,
        );
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: 'cat-grill',
            tenantId: 'demo',
            name: 'Grill',
            slug: 'grill',
            updatedAt: now,
          ),
          mode: InsertMode.insertOrReplace,
        );
    await db.into(db.categoryTranslations).insert(
          CategoryTranslationsCompanion.insert(
            categoryId: 'cat-grill',
            locale: 'en',
            name: 'Grill',
          ),
          mode: InsertMode.insertOrReplace,
        );
    await db.into(db.menuItems).insert(
          MenuItemsCompanion.insert(
            id: 'item-kofta',
            tenantId: 'demo',
            categoryId: 'cat-grill',
            name: 'كفتة',
            description: const Value('Charcoal-grilled minced lamb'),
            basePrice: const Value(180.0),
            updatedAt: now,
          ),
          mode: InsertMode.insertOrReplace,
        );
    await db.into(db.menuItemTranslations).insert(
          MenuItemTranslationsCompanion.insert(
            menuItemId: 'item-kofta',
            locale: 'en',
            name: 'Kofta',
            description: const Value('Charcoal-grilled minced lamb'),
          ),
          mode: InsertMode.insertOrReplace,
        );
    await db.into(db.menuItemVariants).insert(
          MenuItemVariantsCompanion.insert(
            id: 'var-kofta-half',
            menuItemId: 'item-kofta',
            label: 'نصف كيلو',
            labelEn: const Value('Half kilo'),
            price: 180.0,
          ),
          mode: InsertMode.insertOrReplace,
        );
    await db.into(db.syncState).insert(
          SyncStateCompanion.insert(id: const Value(1)),
          mode: InsertMode.insertOrReplace,
        );
  });
}
