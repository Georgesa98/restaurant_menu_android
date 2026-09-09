import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';
import '../../core/i18n/locale_controller.dart';
import 'menu_format.dart';
import 'data/menu_repository.dart'
    show MenuRepository, menuRepositoryProvider, currentMenuTenantId;

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

  List<String> get tags =>
      item.dietaryTagsCsv.split('|').where((t) => t.isNotEmpty).toList();
}

Stream<T> _ready<T>(Ref ref, Stream<T> Function(MenuRepository) pick) async* {
  await ref.watch(dbReadyProvider.future);
  yield* pick(ref.watch(menuRepositoryProvider));
}

final _categoriesStreamProvider = StreamProvider<List<Category>>(
  (ref) => _ready(ref, (r) => r.watchCategories(currentMenuTenantId())),
);
final _categoryTranslationsStreamProvider =
    StreamProvider<List<CategoryTranslation>>(
  (ref) => _ready(ref, (r) => r.watchCategoryTranslations()),
);
final _itemsStreamProvider = StreamProvider.family<List<MenuItem>, String>(
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
    Provider.family<List<MenuItemView>, String>((ref, categoryId) {
  final locale = ref.watch(localeControllerProvider).languageCode;
  final items = ref.watch(_itemsStreamProvider(categoryId)).value ?? [];
  final trs = ref.watch(_itemTranslationsStreamProvider).value ?? [];
  final vars = ref.watch(_variantsStreamProvider).value ?? [];
  final query = ref.watch(searchQueryProvider).trim();
  final views = [for (final i in items) _toView(i, trs, vars, locale)];
  return [
    for (final v in views)
      if (matchesQuery(
        query: query,
        name: v.item.name,
        translatedName: v.name == v.item.name ? null : v.name,
      ))
        v,
  ];
});

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

class _Selection extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? id) => state = id;
}

final selectedCategoryIdProvider =
    NotifierProvider<_Selection, String?>(_Selection.new);

/// Web parity: null selection = "All" (every section stacked).
/// Tapping a tab filters to one section; "All" tab clears back to null.
final showAllProvider =
    Provider<bool>((ref) => ref.watch(selectedCategoryIdProvider) == null);

class _Search extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}

final searchQueryProvider = NotifierProvider<_Search, String>(_Search.new);

class _VariantSelection extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => const {};
  void select(String itemId, int index) => state = {...state, itemId: index};
  int indexOf(String itemId) => state[itemId] ?? -1;
}

final variantSelectionProvider =
    NotifierProvider<_VariantSelection, Map<String, int>>(_VariantSelection.new);
