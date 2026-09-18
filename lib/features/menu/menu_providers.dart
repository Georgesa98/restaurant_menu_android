import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';
import '../../core/i18n/locale_controller.dart';
import 'menu_format.dart';
import 'data/menu_repository.dart'
    show MenuRepository, menuRepositoryProvider;
import 'menu_tenant_id.dart';

class CategoryView {
  const CategoryView({required this.category, required this.name});
  final Category category;
  final String name;
}

class MenuItemView {
  const MenuItemView({
    required this.item,
    required this.name,
    required this.description,
    required this.variants,
  });
  final MenuItem item;
  final String name;
  final String? description;
  final List<MenuItemVariant> variants;
}

Stream<T> _ready<T>(Ref ref, Stream<T> Function(MenuRepository) pick) async* {
  await ref.watch(dbReadyProvider.future);
  yield* pick(ref.watch(menuRepositoryProvider));
}

final _categoriesStreamProvider = StreamProvider<List<Category>>(
  (ref) {
    // Reactive server uuid (falls back to baked id pre-pull).
    final tid = ref.watch(menuTenantIdProvider);
    return _ready(ref, (r) => r.watchCategories(tid));
  },
);
final _categoryTranslationsStreamProvider =
    StreamProvider<List<CategoryTranslation>>(
  (ref) => _ready(ref, (r) => r.watchCategoryTranslations()),
);
final _itemsStreamProvider =
    StreamProvider.autoDispose.family<List<MenuItem>, String>(
  (ref, categoryId) => _ready(ref, (r) => r.watchItems(categoryId)),
);
final _itemTranslationsStreamProvider =
    StreamProvider<List<MenuItemTranslation>>(
  (ref) => _ready(ref, (r) => r.watchMenuItemTranslations()),
);
final _variantsStreamProvider = StreamProvider<List<MenuItemVariant>>(
  (ref) => _ready(ref, (r) => r.watchVariants()),
);

String? _lookup(List<({String locale, String name})> rows, String locale) {
  for (final r in rows) {
    if (r.locale == locale) return r.name;
  }
  return null;
}

final categoryViewsProvider = Provider<List<CategoryView>>((ref) {
  final locale = ref.watch(localeControllerProvider).languageCode;
  final cats = ref.watch(_categoriesStreamProvider).value ?? [];
  final trs = ref.watch(_categoryTranslationsStreamProvider).value ?? [];
  return [
    for (final c in cats)
      CategoryView(
        category: c,
        name: resolveLocalized(
          fallback: c.name,
          translated: _lookup(
            [for (final t in trs.where((t) => t.categoryId == c.id)) (locale: t.locale, name: t.name)],
            locale,
          ),
        ),
      ),
  ];
});

final menuItemViewsProvider =
    Provider.autoDispose.family<List<MenuItemView>, String>((ref, categoryId) {
  final locale = ref.watch(localeControllerProvider).languageCode;
  final items = ref.watch(_itemsStreamProvider(categoryId)).value ?? [];
  final trs = ref.watch(_itemTranslationsStreamProvider).value ?? [];
  final vars = ref.watch(_variantsStreamProvider).value ?? [];
  final views = [for (final i in items) _toView(i, trs, vars, locale)];
  views.sort((a, b) => _featuredFirst(a.item, b.item));
  return views;
});

/// Kiosk order: live pins first, then display order.
int _featuredFirst(MenuItem a, MenuItem b) {
  final fa = isLiveFeatured(
          isFeatured: a.isFeatured, featuredUntil: a.featuredUntil)
      ? 0
      : 1;
  final fb = isLiveFeatured(
          isFeatured: b.isFeatured, featuredUntil: b.featuredUntil)
      ? 0
      : 1;
  final r = fa.compareTo(fb);
  return r != 0 ? r : a.displayOrder.compareTo(b.displayOrder);
}

MenuItemView _toView(
  MenuItem i,
  List<MenuItemTranslation> trs,
  List<MenuItemVariant> vars,
  String locale,
) {
  final mine = trs.where((t) => t.menuItemId == i.id).toList();
  final name = resolveLocalized(
    fallback: i.name,
    translated: _lookup(
      [for (final t in mine) (locale: t.locale, name: t.name)],
      locale,
    ),
  );
  final desc = resolveLocalized(
    fallback: i.description ?? '',
    translated: _lookup(
      [for (final t in mine) (locale: t.locale, name: t.description ?? '')],
      locale,
    ),
  ).trim();
  return MenuItemView(
    item: i,
    name: name,
    description: desc.isEmpty ? null : desc,
    variants: vars.where((v) => v.menuItemId == i.id).toList(),
  );
}

final categoryViewByIdProvider =
    Provider.autoDispose.family<CategoryView?, String>((ref, id) {
  final all = ref.watch(categoryViewsProvider);
  for (final v in all) {
    if (v.category.id == id) return v;
  }
  return null;
});

/// Raw visible-item count per category.
final categoryItemCountProvider =
    Provider.autoDispose.family<int, String>((ref, id) {
  final items = ref.watch(_itemsStreamProvider(id)).value ?? [];
  return items.length;
});

class _DishSearch extends Notifier<String> {
  @override
  String build() => '';
  void set(String v) => state = v;
}

final dishSearchQueryProvider =
    NotifierProvider<_DishSearch, String>(_DishSearch.new);

final _tenantItemsStreamProvider =
    StreamProvider.autoDispose.family<List<MenuItem>, String>(
  (ref, tenantId) => _ready(ref, (r) => r.watchTenantItems(tenantId)),
);

/// Ranked global search across the tenant's categories (name prefix >
/// name contains > description contains, then display order).
final searchResultsProvider =
    Provider.autoDispose<List<({MenuItemView view, int rank})>>((ref) {
  final locale = ref.watch(localeControllerProvider).languageCode;
  final tid = ref.watch(menuTenantIdProvider);
  final q = ref.watch(dishSearchQueryProvider).trim();
  if (tid.isEmpty || q.isEmpty) return [];
  final items = ref.watch(_tenantItemsStreamProvider(tid)).value ?? [];
  final trs = ref.watch(_itemTranslationsStreamProvider).value ?? [];
  final vars = ref.watch(_variantsStreamProvider).value ?? [];
  final ranked = <({MenuItemView view, int rank})>[];
  for (final i in items) {
    final v = _toView(i, trs, vars, locale);
    final rank = searchRank(
      query: q,
      names: [i.name, v.name],
      descriptions: [i.description, v.description],
    );
    if (rank != null) ranked.add((view: v, rank: rank));
  }
  ranked.sort((a, b) {
    final r = a.rank.compareTo(b.rank);
    if (r != 0) return r;
    return _featuredFirst(a.view.item, b.view.item);
  });
  return ranked;
});

class _VariantSelection extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => const {};
  void select(String itemId, int index) => state = {...state, itemId: index};
  int indexOf(String itemId) => state[itemId] ?? -1;
}

final variantSelectionProvider =
    NotifierProvider<_VariantSelection, Map<String, int>>(_VariantSelection.new);
