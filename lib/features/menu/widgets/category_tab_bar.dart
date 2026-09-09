import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/web_palette.dart';
import '../menu_providers.dart';

/// Sticky underline tabs (web `.menu-category-pill`): uppercase, letterspaced,
/// muted → primary with 2px accent underline. First tab is All.
class CategoryTabBar extends ConsumerWidget {
  const CategoryTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final categories = ref.watch(categoryViewsProvider);
    final selected = ref.watch(selectedCategoryIdProvider);
    final showAll = ref.watch(showAllProvider);

    Widget tab({
      required String label,
      required bool active,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? theme.colorScheme.tertiary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.18 * 11,
              color: active
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: const Border(
          bottom: BorderSide(color: WebPalette.hairline, width: 0.5),
        ),
      ),
      // The SliverPersistentHeader delegate fixes this bar at 48px, so the
      // child must paint exactly 48px (Flutter asserts otherwise).
      child: SizedBox(
        height: 48,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              tab(
                label: locale == 'ar' ? 'الكل' : 'All',
                active: showAll,
                onTap: () =>
                    ref.read(selectedCategoryIdProvider.notifier).select(null),
              ),
              for (final c in categories)
                tab(
                  label: c.name,
                  active: selected == c.category.id,
                  onTap: () => ref
                      .read(selectedCategoryIdProvider.notifier)
                      .select(c.category.id),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
