import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/web_palette.dart';
import '../category_icons.dart';
import '../menu_format.dart';
import '../menu_providers.dart';
import '../order_state.dart';
import 'qty_stepper.dart';

/// Web `.menu-card` anatomy: 4:3 photo on cream wash, 12/14/14 body, name +
/// price row, 2-line desc, variant chips with prices, tag pills, stepper row.
class MenuItemCard extends ConsumerWidget {
  const MenuItemCard({super.key, required this.view, required this.categorySlug});

  final MenuItemView view;
  final String categorySlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final quantities = ref.watch(quantitiesProvider);
    final selById = ref.watch(variantSelectionProvider);
    final sel = selById[view.item.id] ?? -1;
    final hasVariants = view.variants.isNotEmpty;
    final selectedVariant =
        hasVariants && sel >= 0 && sel < view.variants.length ? view.variants[sel] : null;
    final qtyKey = orderKey(
      view.item.id,
      hasVariants ? (selectedVariant?.id ?? view.variants.first.id) : null,
    );
    final qty = quantities[qtyKey] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: WebPalette.hairline, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              color: WebPalette.imageWash,
              child: view.item.imageUrl?.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: view.item.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => _PlaceholderIcon(slug: categorySlug),
                      errorWidget: (_, _, _) => _PlaceholderIcon(slug: categorySlug),
                    )
                  : _PlaceholderIcon(slug: categorySlug),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          view.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            color: theme.colorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        displayPrice(
                          basePrice: view.item.basePrice,
                          variantPrices: [
                            for (final v in view.variants) v.price,
                          ],
                          selectedIndex: sel,
                          locale: locale,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: WebPalette.accentText,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  if (view.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      view.description!,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (hasVariants) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (var i = 0; i < view.variants.length; i++)
                          _VariantChip(
                            label: locale == 'ar'
                                ? view.variants[i].label
                                : (view.variants[i].labelEn.isNotEmpty
                                    ? view.variants[i].labelEn
                                    : view.variants[i].label),
                            price: view.variants[i].price,
                            locale: locale,
                            selected: sel == i ||
                                (sel == -1 && i == 0 && qty == 0),
                            hasQty: (quantities[orderKey(view.item.id, view.variants[i].id)] ?? 0) > 0,
                            onTap: () => ref
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
                      runSpacing: 6,
                      children: [
                        for (final t in view.tags)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              t.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.08 * 10,
                                color: theme.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Directionality.of(context) == TextDirection.rtl
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: QtyStepper(
                        qty: qty,
                        qtyKey: qtyKey,
                        addLabel: locale == 'ar' ? 'أضف' : 'Add',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon({required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        categoryIconForSlug(slug),
        size: 36,
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({
    required this.label,
    required this.price,
    required this.locale,
    required this.selected,
    required this.hasQty,
    required this.onTap,
  });

  final String label;
  final double price;
  final String locale;
  final bool selected;
  final bool hasQty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceStr = priceWithCurrency(price, locale);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.tertiary : Colors.transparent,
          border: Border.all(
            color: selected || hasQty
                ? theme.colorScheme.tertiary
                : WebPalette.stepperBorder,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$label · $priceStr',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: selected
                ? Colors.white
                : hasQty
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
