import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/auth/admin_auth.dart';
import '../features/admin/admin_login_page.dart';
import '../features/admin/admin_page.dart';
import '../features/admin/categories_admin_page.dart';
import '../features/admin/items_admin_page.dart';
import '../features/menu/menu_page.dart';

/// Routes: `/` kiosk menu, `/admin/login`, `/admin/*` (guarded: P3 auth).
/// Admin entry stays hidden in the kiosk UI (logo multi-tap).
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final loggedIn = auth.status == AuthStatus.authenticated;
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final at = state.matchedLocation;
      final goingLogin = at == '/admin/login';
      final goingAdmin = at.startsWith('/admin');
      if (goingAdmin && !goingLogin && !loggedIn) {
        if (auth.status == AuthStatus.unauthenticated) return '/admin/login';
        return null; // still checking: let it through, pages handle it
      }
      if (goingLogin && loggedIn) return '/admin';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'menu',
        builder: (context, state) => const MenuPage(),
      ),
      GoRoute(
        path: '/admin/login',
        name: 'admin-login',
        builder: (context, state) => const AdminLoginPage(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminPage(),
        routes: [
          GoRoute(
            path: 'categories',
            name: 'admin-categories',
            builder: (context, state) => const CategoriesAdminPage(),
          ),
          GoRoute(
            path: 'items',
            name: 'admin-items',
            builder: (context, state) => const ItemsAdminPage(),
          ),
        ],
      ),
    ],
  );
});
