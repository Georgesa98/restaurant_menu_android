import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../kiosk/attract_loop.dart';
import '../kiosk/screensaver_controller.dart';
import './menu_providers.dart';
import 'widgets/corner_hotspot.dart';
import 'widgets/menu_section.dart';
import 'widgets/order_bar.dart';

/// Category detail: back bar + single category's item grid.
/// Pushed from the home landing (`/c/:id`); system back returns home.
class CategoryDetailPage extends ConsumerWidget {
  const CategoryDetailPage({super.key, required this.categoryId});

  final String categoryId;

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(categoryViewByIdProvider(categoryId));
    final theme = Theme.of(context);

    ref.listen<bool>(screensaverProvider, (prev, showing) {
      if (showing == true) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => const AttractLoopOverlay(),
                fullscreenDialog: true,
              ),
            )
            .then((_) => ref.read(screensaverProvider.notifier).poke());
      }
    });

    return PopScope(
      // Detail allows back (unlike the locked-down menu root).
      canPop: true,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => ref.read(screensaverProvider.notifier).poke(),
        child: Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                        child: Row(
                          children: [
                            BackButton(
                              onPressed: () => _goBack(context),
                            ),
                            Text(
                              Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? 'القائمة'
                                  : 'Menu',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (view == null)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'الصنف غير موجود'
                              : 'Category not found',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverToBoxAdapter(
                        child: MenuSection(view: view),
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CornerHotspot(
                  onTrigger: () => context.go('/admin/login'),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const OrderBar(),
        ),
      ),
    );
  }
}
