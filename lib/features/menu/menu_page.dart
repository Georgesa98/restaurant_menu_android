import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/tenant_config.dart';
import '../../core/i18n/locale_controller.dart';
import './menu_providers.dart';
import 'widgets/menu_item_card.dart';

/// Customer kiosk page (P1: local drift data). Hidden admin entry: 5 taps.
class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  int _taps = 0;

  void _onTitleTap() {
    _taps++;
    if (_taps >= 5) {
      _taps = 0;
      context.go('/admin/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenant = TenantConfig.current;
    final locale = ref.watch(localeControllerProvider).languageCode;
    final categories = ref.watch(categoryViewsProvider);
    final categoryId = ref.watch(effectiveCategoryIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: _onTitleTap, child: Text(tenant.name)),
        actions: [
          SegmentedButton<String>(
            style: SegmentedButton.styleFrom(visualDensity: VisualDensity.compact),
            segments: const [
              ButtonSegment(value: 'ar', label: Text('عربي')),
              ButtonSegment(value: 'en', label: Text('EN')),
            ],
            selected: {locale},
            onSelectionChanged: (s) =>
                ref.read(localeControllerProvider.notifier).setLocale(s.first),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: categories.isEmpty
          ? Center(
              child: Text(
                locale == 'ar' ? 'لا توجد أصناف بعد' : 'No categories yet',
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;
                final rail = _CategoryRail(
                  categories: categories,
                  selectedId: categoryId,
                  vertical: wide,
                  onSelect: (id) => ref
                      .read(selectedCategoryIdProvider.notifier)
                      .select(id),
                );
                final content = _MenuContent(categoryId: categoryId);
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 240, child: rail),
                      const VerticalDivider(width: 1),
                      Expanded(child: content),
                    ],
                  );
                }
                return Column(
                  children: [rail, Expanded(child: content)],
                );
              },
            ),
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({
    required this.categories,
    required this.selectedId,
    required this.vertical,
    required this.onSelect,
  });

  final List<CategoryView> categories;
  final String? selectedId;
  final bool vertical;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final c in categories)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: ChoiceChip(
            label: Text(c.name),
            selected: c.category.id == selectedId,
            onSelected: (_) => onSelect(c.category.id),
          ),
        ),
    ];
    if (vertical) {
      return ListView(padding: const EdgeInsets.all(8), children: chips);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(children: chips),
    );
  }
}

class _MenuContent extends ConsumerWidget {
  const _MenuContent({required this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    if (categoryId == null) return const SizedBox.shrink();
    final views = ref.watch(menuItemViewsProvider(categoryId!));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: locale == 'ar' ? 'بحث…' : 'Search…',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => ref.read(searchQueryProvider.notifier).set(v),
          ),
        ),
        Expanded(
          child: views.isEmpty
              ? Center(
                  child: Text(
                    locale == 'ar' ? 'لا نتائج' : 'No items found',
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth >= 900
                        ? 3
                        : constraints.maxWidth >= 600
                            ? 2
                            : 1;
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: views.length,
                      itemBuilder: (_, i) => MenuItemCard(view: views[i]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
