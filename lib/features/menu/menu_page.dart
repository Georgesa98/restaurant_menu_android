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
import 'widgets/menu_section.dart';
import 'widgets/order_bar.dart';

/// Kiosk menu home: brand hero + search + category cards landing.
/// Tapping a card pushes `/c/:id`. A non-blank query swaps the landing
/// for ranked global results.
class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryViewsProvider);
    final locale = ref.watch(localeControllerProvider).languageCode;
    final tenantRow = ref.watch(tenantRowProvider).value;
    final theme = Theme.of(context);
    final searching = ref.watch(dishSearchQueryProvider).trim().isNotEmpty;

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
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _DishSearchField(),
                    ),
                  ),
                  if (searching)
                    const SearchResultsSliver()
                  else ...[
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

/// Kiosk search box: writes into [dishSearchQueryProvider] as the user
/// types. Stateful controller so rebuilds (streaming results) never yank
/// the caret.
class _DishSearchField extends ConsumerStatefulWidget {
  const _DishSearchField();

  @override
  ConsumerState<_DishSearchField> createState() => _DishSearchFieldState();
}

class _DishSearchFieldState extends ConsumerState<_DishSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(dishSearchQueryProvider),
    );
    // Rebuild for the clear-button visibility; the query itself is pushed
    // to the provider via onChanged below.
    _controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    return TextField(
      controller: _controller,
      onChanged: (v) => ref.read(dishSearchQueryProvider.notifier).set(v),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: locale == 'ar' ? 'ابحث عن طبق…' : 'Search dishes…',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: locale == 'ar' ? 'مسح' : 'Clear',
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  ref.read(dishSearchQueryProvider.notifier).set('');
                },
              ),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
