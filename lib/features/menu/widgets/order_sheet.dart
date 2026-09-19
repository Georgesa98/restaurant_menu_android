import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/web_palette.dart';
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
            const SizedBox(height: 8),
            _SheetNotice(locale: locale),
            const SizedBox(height: 4),
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

/// Guest-list notice inside the order sheet: the list is not sent
/// anywhere — guests show it to the staff.
class _SheetNotice extends StatelessWidget {
  const _SheetNotice({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: WebPalette.noticeWash,
        border: Border(
          top: BorderSide(color: WebPalette.hairline, width: 0.5),
          bottom: BorderSide(color: WebPalette.hairline, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              locale == 'ar'
                  ? 'قائمتك لا تصل إلى المطبخ — اعرضها على طاقمنا'
                  : 'Your list is not sent to the kitchen — please show it to our staff',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
