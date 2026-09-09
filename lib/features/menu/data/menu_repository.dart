import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/tenant_config.dart';
import '../../../core/db/app_db.dart';
import '../../../core/db/db_provider.dart';

/// Tenant id shared by menu providers (demo seed id; resolved uuid in P2).
String currentMenuTenantId() {
  final baked = TenantConfig.current.tenantId;
  if (baked.isNotEmpty) return baked;
  return TenantConfig.current.slug == 'demo' ? 'demo' : '';
}

/// Streams over the local drift cache (demo seed in P1, server data in P2).
class MenuRepository {
  MenuRepository(this._db);
  final AppDb _db;

  Stream<List<Category>> watchCategories(String tenantId) =>
      _db.watchVisibleCategories(tenantId);

  Stream<List<MenuItem>> watchItems(String categoryId) =>
      _db.watchVisibleItems(categoryId);

  Stream<List<CategoryTranslation>> watchCategoryTranslations() =>
      _db.watchCategoryTranslations();

  Stream<List<MenuItemTranslation>> watchMenuItemTranslations() =>
      _db.watchMenuItemTranslations();

  Stream<List<MenuItemVariant>> watchVariants() => _db.watchMenuItemVariants();
}

final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => MenuRepository(ref.watch(appDbProvider)),
);
