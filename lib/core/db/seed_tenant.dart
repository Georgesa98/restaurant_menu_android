import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'app_db.dart';

const _uuid = Uuid();

/// Seeds a tenant from a bundled JSON asset (see `tool/export-seed.mjs` in the
/// web repo). Used for the demo tenant only. Ids are minted locally (slug is
/// the stable key); the first successful pull wipes seed rows wholesale
/// (docs/PLAN.md §18 replace-on-first-pull), so seed ids never meet server ids.
Future<void> seedTenantFromAsset(
  AppDb db, {
  required String assetPath,
  required String tenantId,
  required String slug,
  required String name,
}) async {
  final raw = await rootBundle.loadString(assetPath);
  final doc = jsonDecode(raw) as Map<String, dynamic>;
  final tenant = doc['tenant'] as Map<String, dynamic>? ?? {};
  final categories = (doc['categories'] as List? ?? []).cast<Map<String, dynamic>>();
  final items = (doc['items'] as List? ?? []).cast<Map<String, dynamic>>();

  String str(String key, String fallback) {
    final v = tenant[key];
    if (v is String && v.trim().isNotEmpty) return v;
    return fallback;
  }

  await db.transaction(() async {
    await db.into(db.tenants).insert(
          TenantsCompanion.insert(
            id: tenantId,
            name: name,
            slug: slug,
            plan: const Value('FREE'),
            isActive: const Value(true),
            primaryColor: Value(str('primaryColor', '#e74c3c')),
            secondaryColor: Value(str('secondaryColor', '#2c3e50')),
            accentColor: Value(str('accentColor', '#f39c12')),
            backgroundColor: Value(str('backgroundColor', '#fdf5e6')),
            surfaceColor: Value(str('surfaceColor', '#ffffff')),
            textColor: Value(str('textColor', '#1a1a2e')),
            textMuted: Value(str('textMuted', '#64748b')),
            headingFont: Value(str('headingFont', 'Cairo')),
            bodyFont: Value(str('bodyFont', 'Inter')),
            borderRadiusSm: Value(str('borderRadiusSm', '4px')),
            borderRadiusMd: Value(str('borderRadiusMd', '8px')),
            borderRadiusLg: Value(str('borderRadiusLg', '16px')),
            cardStyle: Value(str('cardStyle', 'elevated')),
            menuLayout: Value(str('menuLayout', 'single')),
            spacing: Value(str('spacing', 'comfortable')),
            description: Value(tenant['description'] as String?),
            address: Value(tenant['address'] as String?),
            phone: Value(tenant['phone'] as String?),
            instagram: Value(tenant['instagram'] as String?),
            defaultLocale: Value(str('defaultLocale', 'ar')),
            availableLocalesCsv: Value(
              ((tenant['availableLocales'] as List?)?.cast<String>() ?? ['ar', 'en']).join(','),
            ),
            lastSyncAt: const Value(null),
          ),
          mode: InsertMode.insertOrReplace,
        );

    final categoryIds = <String, String>{};
    for (final c in categories) {
      final cslug = c['slug'] as String? ?? '';
      if (cslug.isEmpty) continue;
      final id = _uuid.v4();
      categoryIds[cslug] = id;
      await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              id: id,
              tenantId: tenantId,
              name: c['nameAr'] as String? ?? cslug,
              slug: cslug,
              description: Value(c['descriptionAr'] as String?),
              displayOrder: Value((c['order'] as num?)?.toInt() ?? 0),
              updatedAt: DateTime.now().toUtc().toIso8601String(),
            ),
          );
      await db.into(db.categoryTranslations).insert(
            CategoryTranslationsCompanion.insert(
              categoryId: id,
              locale: 'en',
              name: c['nameEn'] as String? ?? cslug,
              description: Value(c['descriptionEn'] as String?),
            ),
          );
    }

    for (var idx = 0; idx < items.length; idx++) {
      final j = items[idx];
      final catId = categoryIds[j['categorySlug'] as String? ?? ''];
      if (catId == null) continue;
      final id = _uuid.v4();
      final variants = (j['variants'] as List? ?? []).cast<Map<String, dynamic>>();
      // Demo pins: first two dishes pinned (forever) for kiosk QA.
      // Real pins arrive via pull; seed contract is explicit, never default-relied.
      final seedFeatured = (j['isFeatured'] as bool?) ?? idx < 2;
      final seedUntil = j['featuredUntil'] as String?;
      await db.into(db.menuItems).insert(
            MenuItemsCompanion.insert(
              id: id,
              tenantId: tenantId,
              categoryId: catId,
              name: j['name'] as String? ?? '',
              description: Value(j['description'] as String?),
              basePrice: Value(
                variants.isNotEmpty
                    ? null
                    : (j['basePrice'] as num?)?.toDouble(),
              ),
              isAvailable: Value((j['isAvailable'] as bool?) ?? true),
              displayOrder: Value((j['order'] as num?)?.toInt() ?? 0),
              isFeatured: Value(seedFeatured),
              featuredUntil: Value(seedUntil),
              updatedAt: DateTime.now().toUtc().toIso8601String(),
            ),
          );
      await db.into(db.menuItemTranslations).insert(
            MenuItemTranslationsCompanion.insert(
              menuItemId: id,
              locale: 'en',
              name: (j['nameEn'] as String?)?.trim().isNotEmpty == true
                  ? (j['nameEn'] as String)
                  : (j['name'] as String? ?? ''),
              description: const Value(null),
            ),
          );
      for (var i = 0; i < variants.length; i++) {
        final v = variants[i];
        await db.into(db.menuItemVariants).insert(
              MenuItemVariantsCompanion.insert(
                id: _uuid.v4(),
                menuItemId: id,
                label: v['label'] as String? ?? '',
                labelEn: Value(v['labelEn'] as String? ?? ''),
                price: ((v['price'] as num?)?.toDouble() ?? 0),
                sortOrder: Value(i),
              ),
            );
      }
    }

    await db.into(db.syncState).insert(
          SyncStateCompanion.insert(id: const Value(1)),
          mode: InsertMode.insertOrReplace,
        );
  });
}
