import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../kiosk/attract_loop.dart';
import '../kiosk/screensaver_controller.dart';
import './menu_providers.dart';
import 'widgets/corner_hotspot.dart';
import 'widgets/menu_section.dart';
import 'widgets/order_bar.dart';

/// Category detail: back bar + search + single category's item grid.
/// Pushed from the home landing (`/c/:id`); system back returns home.
class CategoryDetailPage extends ConsumerStatefulWidget {
  const CategoryDetailPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<CategoryDetailPage> createState() =>
      _CategoryDetailPageState();
}

class _CategoryDetailPageState extends ConsumerState<CategoryDetailPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() => _query = _controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final view = ref.watch(categoryViewByIdProvider(widget.categoryId));
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

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
                              locale == 'ar' ? 'القائمة' : 'Menu',
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: locale == 'ar'
                              ? 'ابحث في هذا الصنف…'
                              : 'Search this category…',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  tooltip:
                                      locale == 'ar' ? 'مسح' : 'Clear',
                                  icon: const Icon(Icons.clear),
                                  onPressed: _controller.clear,
                                ),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  if (view == null)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          locale == 'ar'
                              ? 'الصنف غير موجود'
                              : 'Category not found',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      sliver: SliverToBoxAdapter(
                        child: MenuSection(view: view, query: _query),
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
