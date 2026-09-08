import 'dart:convert';

import 'package:flutter/services.dart';

/// Baked-at-build tenant identity + fallback branding.
///
/// One APK per tenant: [slug] (and optionally [tenantId]/[name]) are compiled
/// in via `--dart-define` (see `tool/build_tenant.sh`). [fallbackThemeJson]
/// is the offline-first-run safety net; every sync overwrites the local
/// `tenants` row with the server theme (docs/PLAN.md §5).
class TenantConfig {
  const TenantConfig({
    required this.slug,
    required this.tenantId,
    required this.name,
  });

  static const TenantConfig current = TenantConfig(
    slug: String.fromEnvironment('TENANT_SLUG', defaultValue: 'demo'),
    tenantId: String.fromEnvironment('TENANT_ID', defaultValue: ''),
    name: String.fromEnvironment('TENANT_NAME', defaultValue: 'Demo Restaurant'),
  );

  /// Overridden per build: `--dart-define=MENU_API_URL=https://menu.georgesalebe.me`.
  static const String apiBaseUrl = String.fromEnvironment(
    'MENU_API_URL',
    defaultValue: 'https://menu.georgesalebe.me',
  );

  final String slug;
  final String tenantId;
  final String name;

  String get fallbackThemeAsset => 'assets/tenants/$slug/theme.json';

  /// Loads the baked theme.json; falls back to [TenantThemeTokens.defaults]
  /// when the asset is missing (e.g. logo-only tenant without theme file).
  Future<Map<String, dynamic>> loadFallbackThemeJson() async {
    try {
      final raw = await rootBundle.loadString(fallbackThemeAsset);
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return const <String, dynamic>{};
    }
  }
}
