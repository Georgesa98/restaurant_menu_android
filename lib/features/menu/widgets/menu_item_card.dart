import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../menu_format.dart';
import '../menu_providers.dart';

/// One dish card: 4:3 photo, locale name/desc, dietary chips,
/// single-select variant pills with live price.
class MenuItemCard extends ConsumerWidget {
  const MenuItemCard({super.key, required this.view});

  final MenuItemView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sel = ref.watch(variantSelectionProvider)[view.item.id] ?? -1;
    final price = priceLabel(
      basePrice: view.item.basePrice,
      variants: [for (final v in view.variants) (price: v.price)],
      selectedIndex: sel,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: view.item.imageUrl?.isNotEmpty == true
                ? CachedNetworkImage(
                    imageUrl: view.item.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => const _PhotoPlaceholder(),
                    errorWidget: (_, _, _) => const _PhotoPlaceholder(),
                  )
                : const _PhotoPlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        view.name,
                        style: theme.textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
                if (view.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    view.description!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (view.variants.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (var i = 0; i < view.variants.length; i++)
                        ChoiceChip(
                          label: Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? view.variants[i].label
                                : (view.variants[i].labelEn.isNotEmpty
                                    ? view.variants[i].labelEn
                                    : view.variants[i].label),
                          ),
                          selected: sel == i,
                          onSelected: (_) => ref
                              .read(variantSelectionProvider.notifier)
                              .select(view.item.id, i),
                        ),
                    ],
                  ),
                ],
                if (view.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [for (final t in view.tags) Chip(label: Text(t))],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surfaceContainerHighest,
      child: Icon(
        Icons.restaurant,
        size: 48,
        color: scheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}
