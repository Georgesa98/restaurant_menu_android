import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import 'data/menu_repository.dart' show currentMenuTenantId;

/// Single reactive source for the tenant id used by ALL local reads
/// (kiosk menu, attract loop, order lines, admin lists).
///
/// Pulls store rows under the **server uuid**, while the baked config only
/// knows the slug — reading with the baked id is why synced categories were
/// invisible. This provider starts at the baked fallback, adopts the stored
/// server uuid on boot, and follows future pulls/logins via [adopt].
class MenuTenantId extends Notifier<String> {
  @override
  String build() {
    unawaited(_adoptStored());
    return currentMenuTenantId();
  }

  Future<void> _adoptStored() async {
    try {
      final stored =
          await ref.read(secureStorageProvider).read(key: tenantIdKey);
      if (!ref.mounted) return;
      if (stored != null && stored.isNotEmpty && stored != state) {
        state = stored;
      }
    } catch (_) {
      // No secure-storage override (widget/unit tests): keep the fallback.
    }
  }

  /// Called after each pull/login resolves the server tenant id.
  void adopt(String tenantId) {
    if (tenantId.isNotEmpty && tenantId != state) state = tenantId;
  }
}

final menuTenantIdProvider =
    NotifierProvider<MenuTenantId, String>(MenuTenantId.new);
