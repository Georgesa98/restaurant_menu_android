import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/tenant_config.dart';
import '../db/app_db.dart';
import '../db/db_provider.dart';
import 'tenant_theme_tokens.dart';

/// Maps a local `tenants` row (server theme) to controlled tokens.
TenantThemeTokens tokensFromRow(Tenant t) => TenantThemeTokens(
      primaryColor: t.primaryColor,
      secondaryColor: t.secondaryColor,
      accentColor: t.accentColor,
      backgroundColor: t.backgroundColor,
      surfaceColor: t.surfaceColor,
      textColor: t.textColor,
      textMuted: t.textMuted,
      headingFont: t.headingFont,
      bodyFont: t.bodyFont,
      borderRadiusSm: t.borderRadiusSm,
      borderRadiusMd: t.borderRadiusMd,
      borderRadiusLg: t.borderRadiusLg,
      cardStyle: t.cardStyle,
      menuLayout: t.menuLayout,
      spacing: t.spacing,
      logoUrl: t.logoUrl,
      coverUrl: t.coverUrl,
    );

/// Live theme: baked fallback first paint, then the server-pulled row.
/// A rebrand on web applies on next pull with no rebuild (PLAN §5).
final activeTokensProvider = StreamProvider<TenantThemeTokens>((ref) async* {
  final db = ref.watch(appDbProvider);
  final fallbackJson = await TenantConfig.current.loadFallbackThemeJson();
  final fallback = TenantThemeTokens.fromJson(fallbackJson);
  yield fallback;
  await for (final row
      in db.watchTenantBySlug(TenantConfig.current.slug)) {
    yield row == null ? fallback : tokensFromRow(row);
  }
});
