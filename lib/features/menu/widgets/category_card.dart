import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/locale_controller.dart';
import '../../../core/theme/web_palette.dart';
import '../category_icons.dart';
import '../menu_providers.dart';
import '../../kiosk/screensaver_controller.dart';

/// Kiosk-friendly category tile: icon wash on top, name + item count +
/// chevron below. Whole card is one large touch target pushing `/c/:id`.
class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.view});

  final CategoryView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(localeControllerProvider).languageCode;
    final count = ref.watch(categoryItemCountProvider(view.category.id));
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final countLabel = locale == 'ar' ? '$count أصناف' : '$count items';

    return Semantics(
      button: true,
      label: view.name,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ref.read(screensaverProvider.notifier).poke();
            context.push('/c/${view.category.id}');
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: WebPalette.hairline, width: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: WebPalette.imageWash,
                    child: Center(
                      child: Icon(
                        categoryIconForSlug(view.category.slug),
                        size: 40,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
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
                            const SizedBox(height: 2),
                            Text(
                              countLabel,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isRtl
                            ? Icons.chevron_left
                            : Icons.chevron_right,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
