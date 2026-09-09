import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/web_palette.dart';
import '../menu_format.dart';
import '../order_state.dart';
import 'order_sheet.dart';

/// Web `.menu-counter`: sticky primary bar with count + total, opens the sheet.
class OrderBar extends ConsumerWidget {
  const OrderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(orderTotalsProvider);
    if (totals.count <= 0) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: theme.colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => const OrderSheet(),
      ),
      child: Container(
        color: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale == 'ar'
                        ? '${totals.count} أصناف'
                        : '${totals.count} items',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: WebPalette.counterLabel,
                    ),
                  ),
                  Text(
                    locale == 'ar' ? 'اضغط لعرض الطلب' : 'Tap to view order',
                    style: const TextStyle(
                      fontSize: 11,
                      color: WebPalette.counterSub,
                    ),
                  ),
                ],
              ),
              Text(
                priceWithCurrency(totals.total, locale),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.tertiary,
                ),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
