import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../menu_format.dart';
import '../order_state.dart';
import 'qty_stepper.dart';

/// Web `OrderSheet`: line items with steppers, clear-all, total.
class OrderSheet extends ConsumerWidget {
  const OrderSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final entriesAsync = ref.watch(orderEntriesProvider);
    final quantities = ref.watch(quantitiesProvider);
    final totals = ref.watch(orderTotalsProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale == 'ar' ? 'طلبك' : 'Your order',
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            entriesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text(locale == 'ar' ? 'تعذر التحميل' : 'Could not load'),
              ),
              data: (entries) => Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final e = entries[i];
                    final qty = quantities[e.key] ?? 0;
                    if (qty <= 0) return const SizedBox.shrink();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.label),
                      subtitle: Text(
                        e.categoryName,
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            priceWithCurrency(e.price * qty, locale),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(width: 8),
                          QtyStepper(
                            qty: qty,
                            qtyKey: e.key,
                            addLabel: locale == 'ar' ? 'أضف' : 'Add',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () =>
                      ref.read(quantitiesProvider.notifier).clear(),
                  child: Text(locale == 'ar' ? 'مسح الكل' : 'Clear all'),
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
          ],
        ),
      ),
    );
  }
}
