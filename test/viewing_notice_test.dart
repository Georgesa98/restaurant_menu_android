import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/i18n/locale_controller.dart';
import 'package:restaurant_menu_android/features/kiosk/attract_loop.dart';
import 'package:restaurant_menu_android/features/kiosk/screensaver_controller.dart';
import 'package:restaurant_menu_android/features/menu/menu_providers.dart';
import 'package:restaurant_menu_android/features/menu/widgets/menu_hero.dart';
import 'package:restaurant_menu_android/features/menu/widgets/menu_item_card.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guest-list notice: ordering keeps working, but guests are told the list
/// is not sent to the kitchen and must be shown to the staff.

class _StillScreensaver extends Screensaver {
  @override
  bool build() => false;
}

Future<SharedPreferences> _prefs(String locale) async {
  SharedPreferences.setMockInitialValues({'locale': locale});
  return SharedPreferences.getInstance();
}

ProviderScope _scope(SharedPreferences prefs, Widget child) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      screensaverProvider.overrideWith(_StillScreensaver.new),
      attractBrandFilesProvider.overrideWith(
        (ref) async => (logo: null as File?, cover: null as File?),
      ),
    ],
    child: child,
  );
}

MenuItemView _view() => MenuItemView(
      item: MenuItem(
        id: 'item-kofta',
        tenantId: 'demo',
        categoryId: 'cat-grill',
        name: 'كفتة',
        description: 'Charcoal-grilled',
        basePrice: 100,
        imageUrl: null,
        isAvailable: true,
        displayOrder: 0,
        isFeatured: false,
        featuredUntil: null,
        updatedAt: '2026-09-08T00:00:00.000Z',
        isDeleted: false,
        dirty: false,
      ),
      name: 'Kofta',
      description: 'Charcoal-grilled',
      variants: const [],
    );

void main() {
  testWidgets('hero shows the list notice in English', (tester) async {
    final prefs = await _prefs('en');
    await tester.pumpWidget(
      _scope(prefs, const MaterialApp(home: Scaffold(body: MenuHero(tenant: null)))),
    );
    await tester.pump();
    expect(
      find.text('Your list is not sent to the kitchen — please show it to our staff'),
      findsOneWidget,
    );
  });

  testWidgets('hero shows the list notice in Arabic', (tester) async {
    final prefs = await _prefs('ar');
    await tester.pumpWidget(
      _scope(prefs, const MaterialApp(home: Scaffold(body: MenuHero(tenant: null)))),
    );
    await tester.pump();
    expect(find.text('قائمتك لا تصل إلى المطبخ — اعرضها على طاقمنا'), findsOneWidget);
  });

  testWidgets('ordering still works: ADD becomes a stepper', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    final prefs = await _prefs('en');

    await tester.pumpWidget(
      _scope(
        prefs,
        MaterialApp(home: Scaffold(body: MenuItemCard(view: _view(), categorySlug: 'grill'))),
      ),
    );
    await tester.pump();

    expect(find.text('ADD'), findsOneWidget);
    await tester.tap(find.text('ADD'));
    await tester.pump();

    expect(find.text('ADD'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
