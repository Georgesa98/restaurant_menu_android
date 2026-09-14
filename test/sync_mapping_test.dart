import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/core/sync/sync_engine.dart';
import 'package:restaurant_menu_android/core/theme/tenant_theme_tokens.dart';

void main() {
  group('push JSON', () {
    test('category carries translations', () {
      final json = categoryPushJson(
        Category(
          id: 'c1',
          tenantId: 't1',
          name: 'Grill',
          slug: 'grill',
          description: null,
          displayOrder: 0,
          isActive: true,
          updatedAt: 'x',
          isDeleted: false,
          dirty: true,
        ),
        [
          CategoryTranslation(
            categoryId: 'c1',
            locale: 'en',
            name: 'Grill',
            description: null,
            dirty: false,
          ),
        ],
      );
      expect(json['id'], 'c1');
      expect((json['translations'] as List).single['name'], 'Grill');
    });

    test('item splits dietary tags', () {
      final json = itemPushJson(
        MenuItem(
          id: 'i1',
          tenantId: 't1',
          categoryId: 'c1',
          name: 'كفتة',
          description: null,
          basePrice: 180,
          imageUrl: null,
          isAvailable: true,
          displayOrder: 0,
          dietaryTagsCsv: 'spicy|vegan',
          updatedAt: 'x',
          isDeleted: false,
          dirty: true,
        ),
        const [],
        const [],
      );
      expect(json['dietaryTags'], ['spicy', 'vegan']);
      expect(json['variants'], isEmpty);
    });
  });

  group('server parsing', () {
    test('Decimal strings become doubles', () {
      final item = parseServerItem({
        'id': 'i1',
        'categoryId': 'c1',
        'name': 'كفتة',
        'basePrice': '180.50',
        'dietaryTags': ['spicy'],
        'updatedAt': '2026-09-08T00:00:00.000Z',
      }, 't1');
      expect(item.basePrice.value, 180.5);
      expect(item.dietaryTagsCsv.value, 'spicy');
      expect(item.dirty.value, false);
    });

    test('missing optionals default safely', () {
      final cat = parseServerCategory({'id': 'c1', 'name': 'x'}, 't1');
      expect(cat.slug.value, '');
      expect(cat.isActive.value, isTrue);
      expect(cat.isDeleted.value, isFalse);
    });

    test('customCss never reaches tokens', () {
      final tokens = TenantThemeTokens.fromJson({
        'primaryColor': '#111111',
        'customCss': '.menu-item{display:none}',
      });
      expect(tokens.primaryColor, '#111111');
    });
  });
}
