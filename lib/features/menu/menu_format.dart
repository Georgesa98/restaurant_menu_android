import 'package:intl/intl.dart';

/// Pure, unit-tested menu helpers. Prices always use Latin digits
/// (`NumberFormat('en')`); currency symbol arrives per-tenant in P2.
final _digits = NumberFormat.decimalPattern('en');

String formatPrice(double? value) {
  if (value == null) return '';
  return _digits.format(value);
}

/// Web-style price with currency (Latin digits always, owner decision):
/// `SYP 180` in EN, `180 ل.س` in AR.
String priceWithCurrency(double? value, String locale) {
  final n = formatPrice(value);
  if (n.isEmpty) return '';
  return locale == 'ar' ? '$n ل.س' : 'SYP $n';
}

/// Web-style card price line (order-menu.tsx): base price, selected variant
/// price, or `from` min. Latin digits always (owner decision).
String displayPrice({
  required double? basePrice,
  required List<double> variantPrices,
  required int selectedIndex,
  required String locale,
}) {
  if (variantPrices.isEmpty) {
    return priceWithCurrency(basePrice, locale);
  }
  if (selectedIndex >= 0 && selectedIndex < variantPrices.length) {
    return priceWithCurrency(variantPrices[selectedIndex], locale);
  }
  final min =
      variantPrices.reduce((a, b) => a < b ? a : b);
  final n = formatPrice(min);
  return locale == 'ar' ? 'من $n ل.س' : 'from SYP $n';
}

/// Resolve a display string: translation for [locale], else canonical fallback.
String resolveLocalized({
  required String fallback,
  required String? translated,
}) {
  final t = translated?.trim();
  if (t != null && t.isNotEmpty) return t;
  return fallback;
}

/// Kiosk price line. Variants hide `basePrice` (owner decision):
/// no variants → base price; variant picked → its price; otherwise "from" min.
String priceLabel({
  required double? basePrice,
  required List<({double price})> variants,
  required int selectedIndex,
}) {
  if (variants.isEmpty) return formatPrice(basePrice);
  if (selectedIndex >= 0 && selectedIndex < variants.length) {
    return formatPrice(variants[selectedIndex].price);
  }
  final min = variants.map((v) => v.price).reduce((a, b) => a < b ? a : b);
  return 'from ${formatPrice(min)}';
}

/// Bilingual match on canonical + translated names.
bool matchesQuery({
  required String query,
  required String name,
  required String? translatedName,
}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  if (name.toLowerCase().contains(q)) return true;
  return (translatedName ?? '').toLowerCase().contains(q);
}
