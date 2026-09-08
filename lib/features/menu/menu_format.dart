import 'package:intl/intl.dart';

/// Pure, unit-tested menu helpers. Prices always use Latin digits
/// (`NumberFormat('en')`); currency symbol arrives per-tenant in P2.
final _digits = NumberFormat.decimalPattern('en');

String formatPrice(double? value) {
  if (value == null) return '';
  return _digits.format(value);
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
