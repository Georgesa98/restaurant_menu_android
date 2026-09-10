import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/theme/web_palette.dart';
import '../menu_providers.dart';
import 'menu_item_card.dart';

/// Web `.menu-category` section: italic serif header + hairline divider,
/// then the item grid. Owns its item stream (safe for stacked All mode).
class MenuSection extends ConsumerWidget {
  const MenuSection({super.key, required this.view});

  final CategoryView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final views = ref.watch(menuItemViewsProvider(view.category.id));
    final query = ref.watch(searchQueryProvider).trim();
    // menuItemViewsProvider already filters by search; hide empty sections
    // in All mode only when a query is active.
    if (views.isEmpty && query.isNotEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: WebPalette.hairline, width: 0.5),
              ),
            ),
            child: Text(
              view.name,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headlineSmall?.fontFamily,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          if (views.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                locale == 'ar' ? 'لا أصناف متاحة' : 'No items available',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cols = constraints.maxWidth >= 900
                    ? 3
                    : constraints.maxWidth >= 600
                        ? 2
                        : 1;
                // Masonry: cards wrap their content (no fixed aspect stretch).
                return MasonryGridView.count(
                  crossAxisCount: cols,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: views.length,
                  itemBuilder: (_, i) => MenuItemCard(
                    view: views[i],
                    categorySlug: view.category.slug,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
