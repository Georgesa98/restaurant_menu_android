import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';
import '../../core/config/tenant_config.dart';
import '../../core/i18n/locale_controller.dart';
import '../kiosk/attract_loop.dart';
import '../kiosk/screensaver_controller.dart';
import './menu_providers.dart';
import 'widgets/category_tab_bar.dart';
import 'widgets/menu_hero.dart';
import 'widgets/menu_section.dart';
import 'widgets/order_bar.dart';

/// Web-parity kiosk page: hero, sticky tabs (All + sections), stacked
/// sections, sticky order bar. Hidden admin entry: 5 taps on the title.
class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  int _taps = 0;

  void _onTitleTap() {
    _taps++;
    if (_taps >= 5) {
      _taps = 0;
      context.go('/admin/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryViewsProvider);
    final showAll = ref.watch(showAllProvider);
    final selected = ref.watch(selectedCategoryIdProvider);
    final locale = ref.watch(localeControllerProvider).languageCode;
    final tenantRow = ref.watch(_tenantRowProvider).value;

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

    final sections = showAll
        ? categories
        : categories.where((c) => c.category.id == selected).toList();

    // Kiosk lockdown: Android back does nothing on the menu root.
    return PopScope(
      canPop: false,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => ref.read(screensaverProvider.notifier).poke(),
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MenuHero(onTitleTap: _onTitleTap, tenant: tenantRow),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(child: const CategoryTabBar()),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: locale == 'ar' ? 'بحث…' : 'Search…',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) =>
                        ref.read(searchQueryProvider.notifier).set(v),
                  ),
                ),
              ),
              if (categories.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      locale == 'ar' ? 'لا توجد أصناف بعد' : 'No categories yet',
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverList.builder(
                    itemCount: sections.length,
                    itemBuilder: (_, i) => MenuSection(view: sections[i]),
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

final _tenantRowProvider = StreamProvider<Tenant?>((ref) async* {
  await ref.watch(dbReadyProvider.future);
  yield* ref
      .watch(appDbProvider)
      .watchTenantBySlug(TenantConfig.current.slug);
});

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({required this.child});
  final Widget child;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}
