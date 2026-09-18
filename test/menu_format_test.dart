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

  group('priceWithCurrency', () {
    test('EN prefixes SYP, AR suffixes ل.س, Latin digits both', () {
      expect(priceWithCurrency(180, 'en'), 'SYP 180');
      expect(priceWithCurrency(180, 'ar'), '180 ل.س');
      expect(priceWithCurrency(180, 'ar'), isNot(contains(RegExp(r'[٠-٩]'))));
    });
  });

  group('displayPrice', () {
    test('base price when no variants', () {
      expect(
        displayPrice(basePrice: 100, variantPrices: [], selectedIndex: -1, locale: 'en'),
        'SYP 100',
      );
    });

    test('selected variant price', () {
      expect(
        displayPrice(basePrice: 100, variantPrices: [90, 180], selectedIndex: 1, locale: 'ar'),
        '180 ل.س',
      );
    });

    test('from-min when unselected', () {
      expect(
        displayPrice(basePrice: null, variantPrices: [180, 90], selectedIndex: -1, locale: 'en'),
        'from SYP 90',
      );
      expect(
        displayPrice(basePrice: null, variantPrices: [180, 90], selectedIndex: -1, locale: 'ar'),
        'من 90 ل.س',
      );
    });
  });

  group('normalizeForSearch', () {
    test('unifies alef forms and strips diacritics', () {
      expect(normalizeForSearch('أحمد'), 'احمد');
      expect(normalizeForSearch('كَفْتَة'), normalizeForSearch('كفته'));
      expect(normalizeForSearch('  Kofta  '), 'kofta');
    });
  });

  group('searchRank', () {
    test('empty query matches neutrally', () {
      expect(searchRank(query: '  ', names: ['Kofta'], descriptions: []), 1);
    });

    test('name prefix beats name contains beats description', () {
      expect(
        searchRank(query: 'kof', names: ['Kofta'], descriptions: ['grilled']),
        0,
      );
      expect(
        searchRank(query: 'ofta', names: ['Kofta'], descriptions: ['grilled']),
        1,
      );
      expect(
        searchRank(
            query: 'grill', names: ['Kofta'], descriptions: ['Charcoal-grilled']),
        2,
      );
    });

    test('arabic forms cross-match, misses return null', () {
      expect(searchRank(query: 'احمد', names: ['أحمد'], descriptions: []), 0);
      expect(
          searchRank(query: 'zzz', names: ['Kofta'], descriptions: []), isNull);
    });
  });

  group('isLiveFeatured', () {
    test('unpinned is never live', () {
      expect(
        isLiveFeatured(isFeatured: false, featuredUntil: null),
        isFalse,
      );
    });

    test('pin without expiry is live', () {
      expect(
        isLiveFeatured(isFeatured: true, featuredUntil: null),
        isTrue,
      );
    });

    test('expiry window is honored', () {
      final now = DateTime.utc(2026, 9, 14, 12);
      expect(
        isLiveFeatured(
          isFeatured: true,
          featuredUntil: '2026-09-20T20:59:59.000Z',
          now: now,
        ),
        isTrue,
      );
      expect(
        isLiveFeatured(
          isFeatured: true,
          featuredUntil: '2026-09-10T20:59:59.000Z',
          now: now,
        ),
        isFalse,
      );
      expect(
        isLiveFeatured(
          isFeatured: true,
          featuredUntil: 'not-a-date',
          now: now,
        ),
        isFalse,
      );
    });
  });
}
