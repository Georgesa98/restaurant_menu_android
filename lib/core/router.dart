import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/auth/admin_auth.dart';
import '../features/admin/admin_login_page.dart';
import '../features/admin/admin_page.dart';
import '../features/admin/categories_admin_page.dart';
import '../features/admin/items_admin_page.dart';
import '../features/admin/widgets/admin_shell.dart';
import '../features/menu/category_detail_page.dart';
import '../features/menu/menu_page.dart';

/// Routes: `/` kiosk menu, `/admin/login`, `/admin/*` (locked by default).
/// The sync session persists, but admin *screens* need a fresh unlock;
/// re-entry always asks the password again.
///
/// The router itself is stable: it must NOT be recreated on every auth state
/// change (e.g. `working`/`error` during a failed login flipped the whole
/// `MaterialApp.router` back to `/`). Only `loggedIn`/`unlocked` re-evaluate
/// `redirect`, via [routerRefreshProvider].
class _RouterRefresh extends ChangeNotifier {
  void poke() => notifyListeners();
}

final routerRefreshProvider = Provider<Listenable>((ref) {
  final refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);
  // Failed logins only touch working/error — deliberately not listened to.
  ref.listen<bool>(
    authControllerProvider.select((s) => s.status == AuthStatus.authenticated),
    (_, _) => refresh.poke(),
  );
  ref.listen<bool>(adminUnlockedProvider, (_, _) => refresh.poke());
  return refresh;
});

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(routerRefreshProvider);
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn =
          ref.read(authControllerProvider).status ==
          AuthStatus.authenticated;
      final unlocked = ref.read(adminUnlockedProvider);
      final at = state.matchedLocation;
      final goingLogin = at == '/admin/login';
      final goingAdmin = at.startsWith('/admin');
      if (goingAdmin && !goingLogin && !unlocked) return '/admin/login';
      if (goingLogin && loggedIn && unlocked) return '/admin';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'menu',
        builder: (context, state) => const MenuPage(),
      ),
      GoRoute(
        path: '/c/:categoryId',
        name: 'category',
        builder: (context, state) => CategoryDetailPage(
          categoryId: state.pathParameters['categoryId']!,
        ),
      ),
      GoRoute(
        path: '/admin/login',
        name: 'admin-login',
        builder: (context, state) => const AdminLoginPage(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) =>
            const AdminShell(child: AdminPage()),
        routes: [
          GoRoute(
            path: 'categories',
            name: 'admin-categories',
            builder: (context, state) =>
                const AdminShell(child: CategoriesAdminPage()),
          ),
          GoRoute(
            path: 'items',
            name: 'admin-items',
            builder: (context, state) =>
                const AdminShell(child: ItemsAdminPage()),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
