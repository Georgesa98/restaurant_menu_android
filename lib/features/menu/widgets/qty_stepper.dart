import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/web_palette.dart';
import '../order_state.dart';

/// Web `.stepper`: `+ ADD` pill when empty, `− count +` pill otherwise,
/// accent splash ripple on increment.
class QtyStepper extends ConsumerWidget {
  const QtyStepper({
    super.key,
    required this.qty,
    required this.qtyKey,
    required this.addLabel,
  });

  final int qty;
  final String qtyKey;
  final String addLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final latin = Localizations.localeOf(context).languageCode != 'ar';
    Future<void> bump(int delta) =>
        ref.read(quantitiesProvider.notifier).setQuantity(qtyKey, delta);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999),
    );
    if (qty <= 0) {
      return Material(
        color: theme.colorScheme.primary,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          splashColor: theme.colorScheme.tertiary.withValues(alpha: 0.5),
          onTap: () => bump(1),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14, color: theme.scaffoldBackgroundColor),
                const SizedBox(width: 4),
                Text(
                  latin ? addLabel.toUpperCase() : addLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: latin ? 0.05 * 12 : 0,
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: WebPalette.stepperBorder, width: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: Icons.remove,
            onTap: () => bump(-1),
            shape: shape,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 24),
            alignment: Alignment.center,
            child: Text(
              '$qty',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          _StepBtn(
            icon: Icons.add,
            onTap: () => bump(1),
            shape: shape,
            splash: true,
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.icon,
    required this.onTap,
    required this.shape,
    this.splash = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final ShapeBorder shape;
  final bool splash;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        splashColor: splash
            ? theme.colorScheme.tertiary.withValues(alpha: 0.5)
            : null,
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 14, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
