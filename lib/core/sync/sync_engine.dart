import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../config/tenant_config.dart';
import '../db/app_db.dart';
import '../theme/tenant_theme_tokens.dart';

/// Result of a sync step (docs/PLAN.md §7/§18).
enum SyncStatus { ok, fullRepulled, offline, unauthorized, serverError }

class SyncOutcome {
  const SyncOutcome(this.status,
      {this.pulledCategories = 0, this.pulledItems = 0, this.pushed = 0, this.conflicts = 0});
  final SyncStatus status;
  final int pulledCategories;
  final int pulledItems;
  final int pushed;
  final int conflicts;
}

/// Tablet timestamp helpers: server ISO-8601 strings compare lexicographically.
String _nowIso() => DateTime.now().toUtc().toIso8601String();

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

// ---------- outbound: drift rows -> push JSON ----------

Map<String, dynamic> categoryPushJson(
  Category c,
  List<CategoryTranslation> translations,
) {
  return {
    'id': c.id,
    'name': c.name,
    'slug': c.slug,
    'description': c.description,
    'displayOrder': c.displayOrder,
    'isActive': c.isActive,
    'translations': [
      for (final t in translations)
        {'locale': t.locale, 'name': t.name, 'description': t.description},
    ],
  };
}

Map<String, dynamic> itemPushJson(
  MenuItem i,
  List<MenuItemTranslation> translations,
  List<MenuItemVariant> variants,
) {
  return {
    'id': i.id,
    'categoryId': i.categoryId,
    'name': i.name,
    'description': i.description,
    'basePrice': i.basePrice,
    'imageUrl': i.imageUrl,
    'isAvailable': i.isAvailable,
    'displayOrder': i.displayOrder,
    'dietaryTags': i.dietaryTagsCsv.split('|').where((t) => t.isNotEmpty).toList(),
    'translations': [
      for (final t in translations)
        {'locale': t.locale, 'name': t.name, 'description': t.description},
    ],
    'variants': [
      for (final v in variants)
        {
          'id': v.id,
          'label': v.label,
          'labelEn': v.labelEn,
          'price': v.price,
          'sortOrder': v.sortOrder,
        },
    ],
  };
}

// ---------- inbound: server JSON -> drift companions ----------

CategoriesCompanion parseServerCategory(Map<String, dynamic> j, String tenantId) {
  return CategoriesCompanion.insert(
    id: j['id'] as String,
    tenantId: tenantId,
    name: j['name'] as String,
    slug: j['slug'] as String? ?? '',
    description: Value(j['description'] as String?),
    displayOrder: Value((j['displayOrder'] as num?)?.toInt() ?? 0),
    isActive: Value((j['isActive'] as bool?) ?? true),
    updatedAt: j['updatedAt'] as String? ?? _nowIso(),
    isDeleted: Value((j['isDeleted'] as bool?) ?? false),
    dirty: const Value(false),
  );
}

MenuItemsCompanion parseServerItem(
    Map<String, dynamic> j, String tenantId) {
  return MenuItemsCompanion.insert(
    id: j['id'] as String,
    tenantId: tenantId,
    categoryId: j['categoryId'] as String,
    name: j['name'] as String,
    description: Value(j['description'] as String?),
    basePrice: Value(_toDouble(j['basePrice'])),
    imageUrl: Value(j['imageUrl'] as String?),
    isAvailable: Value((j['isAvailable'] as bool?) ?? true),
    displayOrder: Value((j['displayOrder'] as num?)?.toInt() ?? 0),
    dietaryTagsCsv: Value(
      ((j['dietaryTags'] as List?)?.cast<String>() ?? []).join('|'),
    ),
    updatedAt: j['updatedAt'] as String? ?? _nowIso(),
    isDeleted: Value((j['isDeleted'] as bool?) ?? false),
    dirty: const Value(false),
  );
}

TenantThemeTokens tokensFromServerTenant(Map<String, dynamic> j) =>
    TenantThemeTokens.fromJson(j);

// ---------- engine ----------

final syncEngineProvider = Provider<SyncEngine>((ref) {
  throw UnimplementedError('override in main() with db + api');
});

class SyncEngine {
  SyncEngine(this._db, this._api, {this._onTenantResolved});

  final AppDb _db;
  final ApiClient _api;
  final Future<void> Function(String tenantId)? _onTenantResolved;

  Future<String?> _cursor() async {
    final row = await (_db.select(_db.syncState)
          ..where((s) => s.id.equals(1)))
        .getSingleOrNull();
    return row?.lastPullAt;
  }

  Future<void> _saveCursor({String? pullAt, String? pushAt, int? pending}) async {
    final existing = await (_db.select(_db.syncState)
          ..where((s) => s.id.equals(1)))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.syncState).insert(
            SyncStateCompanion.insert(
              id: const Value(1),
              lastPullAt: Value(pullAt),
              lastPushAt: Value(pushAt),
              pendingCount: Value(pending ?? 0),
            ),
          );
      return;
    }
    await (_db.update(_db.syncState)..where((s) => s.id.equals(1))).write(
      SyncStateCompanion(
        lastPullAt: pullAt == null ? const Value.absent() : Value(pullAt),
        lastPushAt: pushAt == null ? const Value.absent() : Value(pushAt),
        pendingCount: pending == null ? const Value.absent() : Value(pending),
      ),
    );
  }

  bool _isOffline(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout;

  /// Push local dirty rows, then pull. 410 stale cursor triggers one full re-pull.
  Future<SyncOutcome> syncNow() async {
    final pushed = await push();
    if (pushed.status == SyncStatus.offline ||
        pushed.status == SyncStatus.unauthorized ||
        pushed.status == SyncStatus.serverError) {
      return pushed;
    }
    final pulled = await pull();
    return SyncOutcome(
      pulled.status,
      pulledCategories: pulled.pulledCategories,
      pulledItems: pulled.pulledItems,
      pushed: pushed.pushed,
      conflicts: pushed.conflicts,
    );
  }

  Future<SyncOutcome> pull({bool full = false}) async {
    final since = full ? null : await _cursor();
    try {
      final res = await _api.get(
        '/api/sync/pull',
        query: {
          'slug': TenantConfig.current.slug,
          if (since case final s) 'since': s,
        },
      );
      final applied = await applyPull(res.data as Map<String, dynamic>);
      return SyncOutcome(
        full ? SyncStatus.fullRepulled : SyncStatus.ok,
        pulledCategories: applied.$1,
        pulledItems: applied.$2,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 410) {
        // Stale cursor: one full re-pull (docs/PLAN.md §18).
        final repulled = await pull(full: true);
        return SyncOutcome(
          SyncStatus.fullRepulled,
          pulledCategories: repulled.pulledCategories,
          pulledItems: repulled.pulledItems,
        );
      }
      if (e.error is UnauthorizedException) {
        return const SyncOutcome(SyncStatus.unauthorized);
      }
      if (_isOffline(e)) return const SyncOutcome(SyncStatus.offline);
      return const SyncOutcome(SyncStatus.serverError);
    }
  }

  /// Applies a pull payload in one transaction. Returns (categories, items).
  /// Tombstones delete locally with cascade; changed parents replace their
  /// full child sets wholesale (translation/variant removals propagate).
  Future<(int, int)> applyPull(Map<String, dynamic> pull) async {
    final serverTime = pull['serverTime'] as String? ?? _nowIso();
    final tenant = pull['tenant'] as Map<String, dynamic>?;
    final categories = (pull['categories'] as List? ?? []).cast<Map<String, dynamic>>();
    final items = (pull['items'] as List? ?? []).cast<Map<String, dynamic>>();
    if (tenant == null) return (0, 0);
    final tenantId = tenant['id'] as String;

    await _db.transaction(() async {
      await _db.into(_db.tenants).insert(
            TenantsCompanion.insert(
              id: tenantId,
              name: tenant['name'] as String? ?? TenantConfig.current.name,
              slug: tenant['slug'] as String? ?? TenantConfig.current.slug,
              plan: Value(tenant['plan'] as String? ?? 'FREE'),
              isActive: Value((tenant['isActive'] as bool?) ?? true),
              primaryColor: Value(tenant['primaryColor'] as String? ?? '#e74c3c'),
              secondaryColor: Value(tenant['secondaryColor'] as String? ?? '#2c3e50'),
              accentColor: Value(tenant['accentColor'] as String? ?? '#f39c12'),
              backgroundColor: Value(tenant['backgroundColor'] as String? ?? '#fdf5e6'),
              surfaceColor: Value(tenant['surfaceColor'] as String? ?? '#ffffff'),
              textColor: Value(tenant['textColor'] as String? ?? '#1a1a2e'),
              textMuted: Value(tenant['textMuted'] as String? ?? '#64748b'),
              headingFont: Value(tenant['headingFont'] as String? ?? 'Cairo'),
              bodyFont: Value(tenant['bodyFont'] as String? ?? 'Inter'),
              borderRadiusSm: Value(tenant['borderRadiusSm'] as String? ?? '4px'),
              borderRadiusMd: Value(tenant['borderRadiusMd'] as String? ?? '8px'),
              borderRadiusLg: Value(tenant['borderRadiusLg'] as String? ?? '16px'),
              cardStyle: Value(tenant['cardStyle'] as String? ?? 'elevated'),
              menuLayout: Value(tenant['menuLayout'] as String? ?? 'single'),
              spacing: Value(tenant['spacing'] as String? ?? 'comfortable'),
              logoUrl: Value(tenant['logoUrl'] as String?),
              coverUrl: Value(tenant['coverUrl'] as String?),
              description: Value(tenant['description'] as String?),
              address: Value(tenant['address'] as String?),
              phone: Value(tenant['phone'] as String?),
              instagram: Value(tenant['instagram'] as String?),
              website: Value(tenant['website'] as String?),
              defaultLocale: Value(tenant['defaultLocale'] as String? ?? 'ar'),
              availableLocalesCsv: Value(
                ((tenant['availableLocales'] as List?)?.cast<String>() ?? ['ar', 'en']).join(','),
              ),
              lastSyncAt: Value(serverTime),
            ),
            mode: InsertMode.insertOrReplace,
          );

      for (final c in categories) {
        final id = c['id'] as String;
        if ((c['isDeleted'] as bool?) ?? false) {
          await _deleteCategoryLocal(id);
        } else {
          await _db.into(_db.categories).insert(
                parseServerCategory(c, tenantId),
                mode: InsertMode.insertOrReplace,
              );
          await (_db.delete(_db.categoryTranslations)
                ..where((t) => t.categoryId.equals(id)))
              .go();
          for (final t in (c['translations'] as List? ?? []).cast<Map<String, dynamic>>()) {
            await _db.into(_db.categoryTranslations).insert(
                  CategoryTranslationsCompanion.insert(
                    categoryId: id,
                    locale: t['locale'] as String,
                    name: t['name'] as String,
                    description: Value(t['description'] as String?),
                  ),
                  mode: InsertMode.insertOrReplace,
                );
          }
        }
      }

      for (final j in items) {
        final id = j['id'] as String;
        if ((j['isDeleted'] as bool?) ?? false) {
          await _deleteItemLocal(id);
        } else {
          await _db.into(_db.menuItems).insert(
                parseServerItem(j, tenantId),
                mode: InsertMode.insertOrReplace,
              );
          await (_db.delete(_db.menuItemTranslations)
                ..where((t) => t.menuItemId.equals(id)))
              .go();
          for (final t in (j['translations'] as List? ?? []).cast<Map<String, dynamic>>()) {
            await _db.into(_db.menuItemTranslations).insert(
                  MenuItemTranslationsCompanion.insert(
                    menuItemId: id,
                    locale: t['locale'] as String,
                    name: t['name'] as String,
                    description: Value(t['description'] as String?),
                  ),
                  mode: InsertMode.insertOrReplace,
                );
          }
          await (_db.delete(_db.menuItemVariants)
                ..where((v) => v.menuItemId.equals(id)))
              .go();
          var order = 0;
          for (final v in (j['variants'] as List? ?? []).cast<Map<String, dynamic>>()) {
            await _db.into(_db.menuItemVariants).insert(
                  MenuItemVariantsCompanion.insert(
                    id: v['id'] as String? ?? '$id-v$order',
                    menuItemId: id,
                    label: v['label'] as String? ?? '',
                    labelEn: Value(v['labelEn'] as String? ?? ''),
                    price: _toDouble(v['price']) ?? 0,
                    sortOrder: Value((v['sortOrder'] as num?)?.toInt() ?? order),
                  ),
                  mode: InsertMode.insertOrReplace,
                );
            order++;
          }
        }
      }

      await _db.into(_db.syncState).insert(
            SyncStateCompanion.insert(
              id: const Value(1),
              lastPullAt: Value(serverTime),
            ),
            mode: InsertMode.insertOrReplace,
          );
    });

    await _onTenantResolved?.call(tenantId);
    return (categories.length, items.length);
  }

  Future<void> _deleteCategoryLocal(String categoryId) async {
    final itemIds = await (_db.select(_db.menuItems)
          ..where((i) => i.categoryId.equals(categoryId)))
        .map((i) => i.id)
        .get();
    for (final itemId in itemIds) {
      await _deleteItemLocal(itemId);
    }
    await (_db.delete(_db.categoryTranslations)
          ..where((t) => t.categoryId.equals(categoryId)))
        .go();
    await (_db.delete(_db.categories)..where((c) => c.id.equals(categoryId))).go();
  }

  Future<void> _deleteItemLocal(String itemId) async {
    await (_db.delete(_db.menuItemTranslations)
          ..where((t) => t.menuItemId.equals(itemId)))
        .go();
    await (_db.delete(_db.menuItemVariants)
          ..where((v) => v.menuItemId.equals(itemId)))
        .go();
    await (_db.delete(_db.menuItems)..where((i) => i.id.equals(itemId))).go();
  }

  /// Pushes dirty rows. Server wins conflicts (applied via [applyPull]-shaped rows).
  Future<SyncOutcome> push() async {
    final cursorRow = await (_db.select(_db.syncState)
          ..where((s) => s.id.equals(1)))
        .getSingleOrNull();
    final baseSince = cursorRow?.lastPushAt ??
        cursorRow?.lastPullAt ??
        DateTime.fromMillisecondsSinceEpoch(0).toUtc().toIso8601String();

    final dirtyCats = await (_db.select(_db.categories)
          ..where((c) => c.dirty.equals(true)))
        .get();
    final dirtyItems = await (_db.select(_db.menuItems)
          ..where((i) => i.dirty.equals(true)))
        .get();
    if (dirtyCats.isEmpty && dirtyItems.isEmpty) {
      return const SyncOutcome(SyncStatus.ok);
    }

    final catIds = dirtyCats.map((c) => c.id).toList();
    final itemIds = dirtyItems.map((i) => i.id).toList();
    final catTrs = await (_db.select(_db.categoryTranslations)
          ..where((t) => t.categoryId.isIn(catIds)))
        .get();
    final itemTrs = await (_db.select(_db.menuItemTranslations)
          ..where((t) => t.menuItemId.isIn(itemIds)))
        .get();
    final variants = await (_db.select(_db.menuItemVariants)
          ..where((v) => v.menuItemId.isIn(itemIds)))
        .get();

    try {
      final res = await _api.post('/api/sync/push', body: {
        'baseSince': baseSince,
        'upserts': {
          'categories': [
            for (final c in dirtyCats.where((c) => !c.isDeleted))
              categoryPushJson(
                c,
                catTrs.where((t) => t.categoryId == c.id).toList(),
              ),
          ],
          'items': [
            for (final i in dirtyItems.where((i) => !i.isDeleted))
              itemPushJson(
                i,
                itemTrs.where((t) => t.menuItemId == i.id).toList(),
                variants.where((v) => v.menuItemId == i.id).toList(),
              ),
          ],
        },
        'deletes': {
          'categoryIds': dirtyCats.where((c) => c.isDeleted).map((c) => c.id).toList(),
          'itemIds': dirtyItems.where((i) => i.isDeleted).map((i) => i.id).toList(),
          'variantIds': const <String>[],
        },
      });

      final data = res.data as Map<String, dynamic>;
      final serverTime = data['serverTime'] as String? ?? _nowIso();
      final accepted = data['accepted'] as Map<String, dynamic>? ?? {};
      final conflicts = data['conflicts'] as Map<String, dynamic>? ?? {};
      var conflictCount = 0;

      await _db.transaction(() async {
        for (final id in (accepted['categoryIds'] as List? ?? []).cast<String>()) {
          await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
            CategoriesCompanion(dirty: const Value(false), updatedAt: Value(serverTime)),
          );
          await (_db.update(_db.categoryTranslations)
                ..where((t) => t.categoryId.equals(id)))
              .write(const CategoryTranslationsCompanion(dirty: Value(false)));
        }
        for (final id in (accepted['itemIds'] as List? ?? []).cast<String>()) {
          await (_db.update(_db.menuItems)..where((i) => i.id.equals(id))).write(
            MenuItemsCompanion(dirty: const Value(false), updatedAt: Value(serverTime)),
          );
          await (_db.update(_db.menuItemTranslations)
                ..where((t) => t.menuItemId.equals(id)))
              .write(const MenuItemTranslationsCompanion(dirty: Value(false)));
          await (_db.update(_db.menuItemVariants)
                ..where((v) => v.menuItemId.equals(id)))
              .write(const MenuItemVariantsCompanion(dirty: Value(false)));
        }
        // Server-wins conflicts: apply returned rows over local edits.
        for (final c in (conflicts['categories'] as List? ?? []).cast<Map<String, dynamic>>()) {
          final tenantId = (c['tenantId'] as String?) ?? TenantConfig.current.tenantId;
          await _db.into(_db.categories).insert(
                parseServerCategory(c, tenantId),
                mode: InsertMode.insertOrReplace,
              );
          conflictCount++;
        }
        for (final j in (conflicts['items'] as List? ?? []).cast<Map<String, dynamic>>()) {
          final tenantId = (j['tenantId'] as String?) ?? TenantConfig.current.tenantId;
          await _db.into(_db.menuItems).insert(
                parseServerItem(j, tenantId),
                mode: InsertMode.insertOrReplace,
              );
          conflictCount++;
        }
      });

      final remainingCats = await (_db.select(_db.categories)
            ..where((c) => c.dirty.equals(true)))
          .get();
      final remainingItems = await (_db.select(_db.menuItems)
            ..where((i) => i.dirty.equals(true)))
          .get();
      await _saveCursor(
        pushAt: serverTime,
        pending: remainingCats.length + remainingItems.length,
      );

      return SyncOutcome(
        SyncStatus.ok,
        pushed: (accepted['categoryIds'] as List? ?? []).length +
            (accepted['itemIds'] as List? ?? []).length,
        conflicts: conflictCount,
      );
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        return const SyncOutcome(SyncStatus.unauthorized);
      }
      if (_isOffline(e)) return const SyncOutcome(SyncStatus.offline);
      return const SyncOutcome(SyncStatus.serverError);
    }
  }
}
