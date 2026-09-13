import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/locale_controller.dart';
import '../../core/theme/web_palette.dart';
import '../kiosk/attract_loop.dart';
import '../kiosk/screensaver_controller.dart';
import './menu_providers.dart';
import 'tenant_provider.dart';
import 'widgets/category_grid.dart';
import 'widgets/corner_hotspot.dart';
import 'widgets/menu_hero.dart';
import 'widgets/order_bar.dart';

/// Kiosk menu home: brand hero + category cards landing.
/// Tapping a card pushes `/c/:id`. No search, no pills.
class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryViewsProvider);
    final locale = ref.watch(localeControllerProvider).languageCode;
    final tenantRow = ref.watch(tenantRowProvider).value;
    final theme = Theme.of(context);

    // Attract loop: present fullscreen on idle, dismiss on any touch.
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

    // Kiosk lockdown: Android back does nothing on the menu root.
    // Hidden admin entry: 2s hold on the bottom-right corner hotspot.
    return PopScope(
      canPop: false,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => ref.read(screensaverProvider.notifier).poke(),
        child: Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: MenuHero(tenant: tenantRow),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: WebPalette.hairline, width: 0.5),
                        ),
                      ),
                      child: Text(
                        locale == 'ar' ? 'تصفح الأصناف' : 'Browse categories',
                        style: TextStyle(
                          fontFamily: theme
                              .textTheme.headlineSmall?.fontFamily,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  if (categories.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          locale == 'ar'
                              ? 'لا توجد أصناف بعد'
                              : 'No categories yet',
                        ),
                      ),
                    )
                  else
                    const CategoryGridSliver(),
                ],
              ),
              // Hidden admin entry: 2s hold, bottom-right corner.
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
