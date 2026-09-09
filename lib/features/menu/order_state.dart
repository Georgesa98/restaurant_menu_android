import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drift/drift.dart';

import '../../core/config/tenant_config.dart';
import '../../core/db/db_provider.dart';
import '../../core/i18n/locale_controller.dart';
import 'data/menu_repository.dart' show currentMenuTenantId;

/// One order line, keyed exactly like web (`itemId` or `itemId:variantId`).
class OrderEntry {
  const OrderEntry({
    required this.key,
    required this.itemId,
    this.variantId,
    required this.label,
    required this.price,
    required this.categoryName,
  });
  final String key;
  final String itemId;
  final String? variantId;
  final String label;
  final double price;
  final String categoryName;
}

String orderKey(String itemId, [String? variantId]) =>
    variantId == null ? itemId : '$itemId:$variantId';

/// Quantities persisted per tenant slug (`menu-order:<slug>`, like web
/// localStorage). Keyed `itemId` or `itemId:variantId`.
class Quantities extends Notifier<Map<String, int>> {
  static String _prefsKey(String slug) => 'menu-order:$slug';

  @override
  Map<String, int> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_prefsKey(TenantConfig.current.slug));
    if (raw == null || raw.isEmpty) return const {};
    // Minimal parse: "id:vid=2;id2=1". Corrupt data resets silently (web parity).
    try {
      final map = <String, int>{};
      for (final part in raw.split(';')) {
        final kv = part.split('=');
        if (kv.length != 2) continue;
        final qty = int.tryParse(kv[1]);
        if (qty != null && qty > 0) map[kv[0]] = qty;
      }
      return map;
    } catch (_) {
      return const {};
    }
  }

  Future<void> _persist(Map<String, int> map) async {
    await ref.read(sharedPreferencesProvider).setString(
          _prefsKey(TenantConfig.current.slug),
          map.entries.map((e) => '${e.key}=${e.value}').join(';'),
        );
  }

  Future<void> setQuantity(String key, int delta) async {
    final next = Map<String, int>.of(state);
    final updated = (next[key] ?? 0) + delta;
    if (updated <= 0) {
      next.remove(key);
    } else {
      next[key] = updated;
    }
    state = Map.unmodifiable(next);
    await _persist(next);
  }

  Future<void> clear() async {
    state = const {};
    await _persist(const {});
  }
}

final quantitiesProvider =
    NotifierProvider<Quantities, Map<String, int>>(Quantities.new);

/// Resolved order lines (label in current locale, live prices).
final orderEntriesProvider = FutureProvider<List<OrderEntry>>((ref) async {
  await ref.watch(dbReadyProvider.future);
  final quantities = ref.watch(quantitiesProvider);
  if (quantities.isEmpty) return const [];
  final locale = ref.watch(localeControllerProvider).languageCode;
  final db = ref.watch(appDbProvider);
  final tid = currentMenuTenantId();
  if (tid.isEmpty) return const [];

  final cats = await (db.select(db.categories)
        ..where((c) => c.tenantId.equals(tid) & c.isDeleted.equals(false)))
      .get();
  final catName = <String, String>{};
  for (final c in cats) {
    final tr = await (db.select(db.categoryTranslations)
          ..where((t) => t.categoryId.equals(c.id) & t.locale.equals(locale)))
        .getSingleOrNull();
    catName[c.id] = (tr?.name.trim().isNotEmpty == true) ? tr!.name : c.name;
  }
  final items = await (db.select(db.menuItems)
        ..where((i) => i.tenantId.equals(tid) & i.isDeleted.equals(false)))
      .get();
  final byId = {for (final i in items) i.id: i};

  final entries = <OrderEntry>[];
  for (final kv in quantities.entries) {
    final parts = kv.key.split(':');
    final item = byId[parts[0]];
    if (item == null || !item.isAvailable) continue;
    final tr = await (db.select(db.menuItemTranslations)
          ..where((t) =>
              t.menuItemId.equals(item.id) & t.locale.equals(locale)))
        .getSingleOrNull();
    final name = (tr?.name.trim().isNotEmpty == true) ? tr!.name : item.name;
    if (parts.length > 1) {
      final v = await (db.select(db.menuItemVariants)
            ..where((x) => x.id.equals(parts[1]) & x.isDeleted.equals(false)))
          .getSingleOrNull();
      if (v == null) continue;
      final vLabel = locale == 'ar'
          ? v.label
          : (v.labelEn.isNotEmpty ? v.labelEn : v.label);
      entries.add(OrderEntry(
        key: kv.key,
        itemId: item.id,
        variantId: v.id,
        label: '$name — $vLabel',
        price: v.price,
        categoryName: catName[item.categoryId] ?? '',
      ));
    } else {
      entries.add(OrderEntry(
        key: kv.key,
        itemId: item.id,
        label: name,
        price: item.basePrice ?? 0,
        categoryName: catName[item.categoryId] ?? '',
      ));
    }
  }
  return entries;
});

final orderTotalsProvider = Provider<({int count, double total})>((ref) {
  final quantities = ref.watch(quantitiesProvider);
  final entries = ref.watch(orderEntriesProvider).value ?? [];
  var count = 0;
  var total = 0.0;
  for (final e in entries) {
    final qty = quantities[e.key] ?? 0;
    count += qty;
    total += e.price * qty;
  }
  return (count: count, total: total);
});
