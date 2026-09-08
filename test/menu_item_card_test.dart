import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/features/menu/menu_providers.dart';
import 'package:restaurant_menu_android/features/menu/widgets/menu_item_card.dart';

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
        dietaryTagsCsv: '',
        updatedAt: '2026-09-08T00:00:00.000Z',
        isDeleted: false,
        dirty: false,
      ),
      name: 'Kofta',
      description: 'Charcoal-grilled',
      variants: [
        MenuItemVariant(
          id: 'v1',
          menuItemId: 'item-kofta',
          label: 'نصف',
          labelEn: 'Half',
          price: 100,
          sortOrder: 0,
          isDeleted: false,
          dirty: false,
        ),
        MenuItemVariant(
          id: 'v2',
          menuItemId: 'item-kofta',
          label: 'كيلو',
          labelEn: 'Full',
          price: 180,
          sortOrder: 1,
          isDeleted: false,
          dirty: false,
        ),
      ],
    );

void main() {
  testWidgets('variant tap switches the displayed price', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: _Card())),
      ),
    );

    expect(find.text('from 100'), findsOneWidget);

    await tester.tap(find.text('Full'));
    await tester.pump();

    expect(find.text('180'), findsOneWidget);
    expect(find.text('from 100'), findsNothing);
  });
}

class _Card extends StatelessWidget {
  const _Card();

  @override
  Widget build(BuildContext context) => MenuItemCard(view: _view());
}
