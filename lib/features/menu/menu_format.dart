import 'package:intl/intl.dart';

/// Pure, unit-tested menu helpers. Prices always use Latin digits
/// (`NumberFormat('en')`); currency is SYP-only per owner (2026-09-14) —
/// no per-tenant currency column.
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

/// Owner pin liveness: pinned while [featuredUntil] is null or in the
/// future. Same spec as the web menu (`lib/search.ts isLiveFeatured`).
bool isLiveFeatured({
  required bool isFeatured,
  required String? featuredUntil,
  DateTime? now,
}) {
  if (!isFeatured) return false;
  if (featuredUntil == null || featuredUntil.trim().isEmpty) return true;
  final until = DateTime.tryParse(featuredUntil);
  if (until == null) return false;
  return until.isAfter(now ?? DateTime.now());
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

/// Search normalization: lowercase, strip Arabic diacritics (tashkeel), and
/// unify alef/hamza + waw/hamza + yaa/hamza + taa-marbuta forms so `أحمد`
/// matches `احمد` and `كفته` matches `كفتة`. Same spec as the web menu.
String normalizeForSearch(String s) {
  var n = s.trim().toLowerCase();
  n = n.replaceAll(RegExp('[\u064B-\u0652\u0670]'), '');
  n = n.replaceAll(RegExp('[أإآٱ]'), 'ا');
  n = n.replaceAll('ؤ', 'و').replaceAll('ئ', 'ي');
  n = n.replaceAll('ة', 'ه');
  n = n.replaceAll(RegExp(r'\s+'), ' ');
  return n;
}

/// Rank a dish against [query]: 0 = name prefix, 1 = name contains,
/// 2 = description contains, null = no match. Empty query matches all at
/// rank 1 (neutral — callers keep display order).
int? searchRank({
  required String query,
  required List<String?> names,
  required List<String?> descriptions,
}) {
  final q = normalizeForSearch(query);
  if (q.isEmpty) return 1;
  final ns = [
    for (final n in names)
      if (n != null && n.trim().isNotEmpty) normalizeForSearch(n),
  ];
  if (ns.any((n) => n.startsWith(q))) return 0;
  if (ns.any((n) => n.contains(q))) return 1;
  final ds = [
    for (final d in descriptions)
      if (d != null && d.trim().isNotEmpty) normalizeForSearch(d),
  ];
  if (ds.any((d) => d.contains(q))) return 2;
  return null;
}
