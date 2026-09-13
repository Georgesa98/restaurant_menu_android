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
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final loggedIn = auth.status == AuthStatus.authenticated;
  final unlocked = ref.watch(adminUnlockedProvider);
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
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
});
