import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../menu_providers.dart';
import 'category_card.dart';

/// Sliver grid of [CategoryCard] for the menu home landing.
/// 2 columns on phones, 3 on wide tablets. Fixed extent keeps every
/// tile a uniform kiosk touch target.
class CategoryGridSliver extends ConsumerWidget {
  const CategoryGridSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryViewsProvider);
    final width = MediaQuery.sizeOf(context).width;
    final cols = width >= 900 ? 3 : 2;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 184,
        ),
        itemCount: categories.length,
        itemBuilder: (_, i) => CategoryCard(view: categories[i]),
      ),
    );
  }
}
