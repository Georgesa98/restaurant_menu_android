import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_menu_android/core/i18n/locale_controller.dart';
import 'package:restaurant_menu_android/features/kiosk/attract_loop.dart';
import 'package:restaurant_menu_android/features/menu/widgets/menu_hero.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Hidden admin entry backup: 5 taps on the brand title open admin login.
void main() {
  testWidgets('5 taps on the brand title open admin login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) =>
              const Scaffold(body: MenuHero(tenant: null)),
        ),
        GoRoute(
          path: '/admin/login',
          builder: (_, _) => const Scaffold(body: Text('login')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          // Skip path_provider (no test implementation): brand files are
          // decoration, and the real lookup's timeout would outlive the test.
          attractBrandFilesProvider.overrideWith(
            (ref) async => (logo: null as File?, cover: null as File?),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    final title = find.text('Demo Restaurant');
    expect(title, findsOneWidget);
    expect(find.text('login'), findsNothing);
    for (var i = 0; i < 4; i++) {
      await tester.tap(title);
      await tester.pump();
    }
    expect(find.text('login'), findsNothing);
    await tester.tap(title);
    await tester.pumpAndSettle();
    expect(find.text('login'), findsOneWidget);
  });
}
