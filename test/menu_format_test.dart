import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/features/menu/menu_format.dart';

void main() {
  group('formatPrice', () {
    test('uses Latin digits', () {
      expect(formatPrice(180), '180');
      expect(formatPrice(180.5), contains('180'));
      expect(formatPrice(180.5), isNot(contains(RegExp(r'[٠-٩]'))));
    });

    test('null maps to empty', () {
      expect(formatPrice(null), '');
    });
  });

  group('priceLabel', () {
    test('no variants shows base price', () {
      expect(priceLabel(basePrice: 100, variants: [], selectedIndex: -1), '100');
    });

    test('selected variant shows its price', () {
      const variants = [(price: 100.0), (price: 180.0)];
      expect(
        priceLabel(basePrice: 100, variants: variants, selectedIndex: 1),
        '180',
      );
    });

    test('unselected variants show from-min', () {
      const variants = [(price: 180.0), (price: 100.0)];
      expect(
        priceLabel(basePrice: null, variants: variants, selectedIndex: -1),
        'from 100',
      );
    });
  });

  group('resolveLocalized', () {
    test('prefers non-empty translation', () {
      expect(
        resolveLocalized(fallback: 'كفتة', translated: 'Kofta'),
        'Kofta',
      );
    });

    test('falls back on empty translation', () {
      expect(resolveLocalized(fallback: 'كفتة', translated: '  '), 'كفتة');
      expect(resolveLocalized(fallback: 'كفتة', translated: null), 'كفتة');
    });
  });

  group('matchesQuery', () {
    test('empty query matches all', () {
      expect(matchesQuery(query: '', name: 'x', translatedName: null), isTrue);
    });

    test('matches canonical or translation, case-insensitive', () {
      expect(
        matchesQuery(query: 'kof', name: 'كفتة', translatedName: 'Kofta'),
        isTrue,
      );
      expect(
        matchesQuery(query: 'كف', name: 'كفتة', translatedName: 'Kofta'),
        isTrue,
      );
      expect(
        matchesQuery(query: 'shawarma', name: 'كفتة', translatedName: 'Kofta'),
        isFalse,
      );
    });
  });
}
