import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Baked-at-build tenant identity + fallback branding.
///
/// One APK per tenant. Each value resolves per key in this order:
/// 1. explicit `--dart-define` (so `tool/build_tenant.sh` release builds win
///    over any dev `.env` that happens to be bundled),
/// 2. `.env` asset (loaded in `main()`; local-dev convenience),
/// 3. compiled default below.
///
/// `.env` is gitignored — see `.env.example`. Fresh clones/CI without a
/// `.env` fall back to defines/defaults; a missing file is swallowed in
/// `main()` for exactly this reason. Tests (no dotenv load) resolve to
/// defines/defaults since `dotenv.env` is empty before load.
class TenantConfig {
  const TenantConfig({
    required this.slug,
    required this.tenantId,
    required this.name,
  });

  // --dart-define inputs (also the no-.env defaults).
  static const _slugDefine =
      String.fromEnvironment('TENANT_SLUG', defaultValue: 'demo');
  static const _idDefine =
      String.fromEnvironment('TENANT_ID', defaultValue: '');
  static const _nameDefine = String.fromEnvironment(
    'TENANT_NAME',
    defaultValue: 'Demo Restaurant',
  );
  static const _apiDefine = String.fromEnvironment(
    'MENU_API_URL',
    defaultValue: 'https://menu.georgesalebe.me',
  );

  static String _resolve({
    required String dotEnvKey,
    required String defineValue,
    required String defaultValue,
  }) {
    // A define counts as explicit when it differs from its default
    // (for TENANT_ID the default is empty, so any non-empty value wins).
    if (defineValue != defaultValue) return defineValue;
    // dotenv.env throws before load() (tests, fresh isolates) — treat as empty.
    final fromEnv =
        dotenv.isInitialized ? dotenv.env[dotEnvKey]?.trim() : null;
    if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
    return defaultValue;
  }

  static TenantConfig get current => TenantConfig(
        slug: _resolve(
          dotEnvKey: 'TENANT_SLUG',
          defineValue: _slugDefine,
          defaultValue: 'demo',
        ),
        tenantId: _resolve(
          dotEnvKey: 'TENANT_ID',
          defineValue: _idDefine,
          defaultValue: '',
        ),
        name: _resolve(
          dotEnvKey: 'TENANT_NAME',
          defineValue: _nameDefine,
          defaultValue: 'Demo Restaurant',
        ),
      );

  /// Server base URL: explicit `--dart-define=MENU_API_URL=...`, else `.env`,
  /// else production default.
  static String get apiBaseUrl => _resolve(
        dotEnvKey: 'MENU_API_URL',
        defineValue: _apiDefine,
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
