import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/admin_login_page.dart';
import '../features/admin/admin_page.dart';
import '../features/menu/menu_page.dart';

/// Routes: `/` kiosk menu, `/admin/login`, `/admin/*` (guarded in P3).
/// Admin entry stays hidden in the kiosk UI (logo multi-tap).
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
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
      ),
    ],
  );
});
