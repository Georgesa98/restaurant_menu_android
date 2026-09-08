import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_client.dart';
import '../../../core/config/tenant_config.dart';
import '../../../core/db/app_db.dart';
import '../../../core/db/db_provider.dart';

const _uuid = Uuid();

String newId() => _uuid.v4();
String _nowIso() => DateTime.now().toUtc().toIso8601String();

/// URL-safe slug for offline-created rows (server enforces uniqueness).
String slugify(String name) {
  var s = name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
  s = s.replaceAll(RegExp(r'[^a-z0-9\-]'), '');
  s = s.replaceAll(RegExp(r'-{2,}'), '-').replaceAll(RegExp(r'^-|-$'), '');
  if (s.isEmpty) s = 'item-${DateTime.now().millisecondsSinceEpoch}';
  return s;
}

class VariantInput {
  const VariantInput({
    this.id,
    required this.label,
    this.labelEn = '',
    required this.price,
  });
  final String? id;
  final String label;
  final String labelEn;
  final double price;
}

/// All admin writes mark parents dirty + stamp local updatedAt; the next
/// push ships them and the server restamps (docs/PLAN.md §7/§18).
class AdminWrites {
  AdminWrites(this._db);
  final AppDb _db;

  Future<String> saveCategory({
    String? id,
    required String tenantId,
    required String name,
    String? slug,
    String? description,
    int displayOrder = 0,
    bool isActive = true,
    String? enName,
    String? enDescription,
  }) async {
    final now = _nowIso();
    final cid = id ?? newId();
    final cslug = (slug?.trim().isNotEmpty == true) ? slug!.trim() : slugify(name);
    await _db.transaction(() async {
      await _db.into(_db.categories).insert(
            CategoriesCompanion.insert(
            id: cid,
            tenantId: tenantId,
            name: name.trim(),
            slug: cslug,
              description: Value(
                description?.trim().isEmpty == true ? null : description?.trim(),
              ),
              displayOrder: Value(displayOrder),
              isActive: Value(isActive),
              updatedAt: now,
              isDeleted: const Value(false),
              dirty: const Value(true),
            ),
            mode: InsertMode.insertOrReplace,
          );
      if ((enName?.trim().isNotEmpty == true)) {
        await _db.into(_db.categoryTranslations).insert(
              CategoryTranslationsCompanion.insert(
                categoryId: cid,
                locale: 'en',
                name: enName!.trim(),
                description: Value(
                  enDescription?.trim().isEmpty == true ? null : enDescription?.trim(),
                ),
                dirty: const Value(true),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    });
    return cid;
  }

  Future<void> setCategoryActive(String id, bool active) =>
      _touchCategory(id, CategoriesCompanion(isActive: Value(active)));

  Future<void> deleteCategory(String id) async {
    final now = _nowIso();
    await _db.transaction(() async {
      await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
        CategoriesCompanion(
          isDeleted: const Value(true),
          dirty: const Value(true),
          updatedAt: Value(now),
        ),
      );
      await (_db.update(_db.menuItems)..where((i) => i.categoryId.equals(id))).write(
        MenuItemsCompanion(
          isDeleted: const Value(true),
          dirty: const Value(true),
          updatedAt: Value(now),
        ),
      );
    });
  }

  Future<void> reorderCategories(List<String> idsInOrder) async {
    final now = _nowIso();
    await _db.transaction(() async {
      for (var i = 0; i < idsInOrder.length; i++) {
        await (_db.update(_db.categories)..where((c) => c.id.equals(idsInOrder[i]))).write(
          CategoriesCompanion(
            displayOrder: Value(i),
            dirty: const Value(true),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }

  Future<void> _touchCategory(String id, CategoriesCompanion patch) async {
    await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
      patch.copyWith(dirty: const Value(true), updatedAt: Value(_nowIso())),
    );
  }

  Future<String> saveItem({
    String? id,
    required String tenantId,
    required String categoryId,
    required String name,
    String? description,
    double? basePrice,
    String? imageUrl,
    bool isAvailable = true,
    int displayOrder = 0,
    List<String> dietaryTags = const [],
    String? enName,
    String? enDescription,
    List<VariantInput> variants = const [],
  }) async {
    final now = _nowIso();
    final iid = id ?? newId();
    await _db.transaction(() async {
      await _db.into(_db.menuItems).insert(
            MenuItemsCompanion.insert(
              id: iid,
              tenantId: tenantId,
              categoryId: categoryId,
              name: name.trim(),
              description: Value(
                description?.trim().isEmpty == true ? null : description?.trim(),
              ),
              basePrice: Value(basePrice),
              imageUrl: Value(
                imageUrl?.trim().isEmpty == true ? null : imageUrl?.trim(),
              ),
              isAvailable: Value(isAvailable),
              displayOrder: Value(displayOrder),
              dietaryTagsCsv: Value(dietaryTags.join('|')),
              updatedAt: now,
              isDeleted: const Value(false),
              dirty: const Value(true),
            ),
            mode: InsertMode.insertOrReplace,
          );
      if (enName?.trim().isNotEmpty == true) {
        await _db.into(_db.menuItemTranslations).insert(
              MenuItemTranslationsCompanion.insert(
                menuItemId: iid,
                locale: 'en',
                name: enName!.trim(),
                description: Value(
                  enDescription?.trim().isEmpty == true ? null : enDescription?.trim(),
                ),
                dirty: const Value(true),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      // Replace variant set: tombstone old, create new (mirrors server PUT).
      await (_db.update(_db.menuItemVariants)
            ..where((v) => v.menuItemId.equals(iid) & v.isDeleted.equals(false)))
          .write(
        const MenuItemVariantsCompanion(
          isDeleted: Value(true),
          dirty: Value(true),
        ),
      );
      for (var i = 0; i < variants.length; i++) {
        final v = variants[i];
        await _db.into(_db.menuItemVariants).insert(
              MenuItemVariantsCompanion.insert(
                id: v.id ?? newId(),
                menuItemId: iid,
                label: v.label.trim(),
                labelEn: Value(v.labelEn.trim()),
                price: v.price,
                sortOrder: Value(i),
                dirty: const Value(true),
              ),
            );
      }
    });
    return iid;
  }

  Future<void> setItemAvailable(String id, bool available) async {
    await (_db.update(_db.menuItems)..where((i) => i.id.equals(id))).write(
      MenuItemsCompanion(
        isAvailable: Value(available),
        dirty: const Value(true),
        updatedAt: Value(_nowIso()),
      ),
    );
  }

  Future<void> deleteItem(String id) async {
    await (_db.update(_db.menuItems)..where((i) => i.id.equals(id))).write(
      MenuItemsCompanion(
        isDeleted: const Value(true),
        dirty: const Value(true),
        updatedAt: Value(_nowIso()),
      ),
    );
  }

  Future<void> reorderItems(List<String> idsInOrder) async {
    final now = _nowIso();
    await _db.transaction(() async {
      for (var i = 0; i < idsInOrder.length; i++) {
        await (_db.update(_db.menuItems)..where((x) => x.id.equals(idsInOrder[i]))).write(
          MenuItemsCompanion(
            displayOrder: Value(i),
            dirty: const Value(true),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }
}

final adminWritesProvider =
    Provider<AdminWrites>((ref) => AdminWrites(ref.watch(appDbProvider)));

/// Tenant id for local writes: resolved uuid (post-pull/login) → baked id →
/// demo seed id. Empty means "no tenant yet" (fresh non-demo install pre-sync).
Future<String> resolveWriteTenantId(SecureStore store) async {
  final stored = await store.read(key: 'tenant_id');
  if (stored?.isNotEmpty == true) return stored!;
  if (TenantConfig.current.tenantId.isNotEmpty) {
    return TenantConfig.current.tenantId;
  }
  return TenantConfig.current.slug == 'demo' ? 'demo' : '';
}
