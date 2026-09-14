import 'package:flutter/material.dart';

import 'tenant_theme_tokens.dart';

/// Maps controlled [TenantThemeTokens] to Flutter [ThemeData].
/// Unknown/malformed values fall back to defaults — never crash on theming.
class TenantThemeMapper {
  const TenantThemeMapper._();

  static Color parseHex(String raw, Color fallback) {
    var hex = raw.trim().replaceFirst('#', '');
    if (hex.length == 3) {
      hex = hex.split('').map((c) => '$c$c').join();
    }
    if (hex.length == 6) hex = 'ff$hex';
    if (hex.length != 8) return fallback;
    final value = int.tryParse(hex, radix: 16);
    return value == null ? fallback : Color(value);
  }

  static double parsePx(String raw, double fallback) {
    final cleaned = raw.trim().toLowerCase().replaceAll('px', '');
    final value = double.tryParse(cleaned) ?? fallback;
    // A negative radius asserts in debug and clips in release — clamp it.
    // Absurd values fall back instead of breaking layout.
    if (value < 0 || value > 64) return fallback;
    return value;
  }

  /// Web font names map to bundled families; anything else → [fallback].
  static String mapFont(String raw, String fallback) {
    final lower = raw.toLowerCase();
    if (lower.contains('cairo') || lower.contains('arab')) return 'Cairo';
    if (lower.contains('inter')) return 'Inter';
    if (lower.contains('georgia') || lower.contains('serif')) return 'Cairo';
    return fallback;
  }

  static ThemeData toThemeData(TenantThemeTokens t) {
    const fb = TenantThemeTokens.defaults;
    final primary = parseHex(t.primaryColor, parseHex(fb.primaryColor, Colors.red));
    final secondary = parseHex(
      t.secondaryColor,
      parseHex(fb.secondaryColor, Colors.blueGrey),
    );
    final accent = parseHex(t.accentColor, parseHex(fb.accentColor, Colors.amber));
    final background = parseHex(
      t.backgroundColor,
      parseHex(fb.backgroundColor, const Color(0xFFFDF5E6)),
    );
    final surface = parseHex(t.surfaceColor, parseHex(fb.surfaceColor, Colors.white));
    final text = parseHex(t.textColor, parseHex(fb.textColor, const Color(0xFF1A1A2E)));
    final textMuted = parseHex(
      t.textMuted,
      parseHex(fb.textMuted, const Color(0xFF64748B)),
    );
    final radiusMd = parsePx(t.borderRadiusMd, 8);
    final bodyFont = mapFont(t.bodyFont, 'Inter');
    final headingFont = mapFont(t.headingFont, 'Cairo');
    final comfortable = t.spacing.toLowerCase() != 'compact';
    final cardElevated = t.cardStyle.toLowerCase() != 'outlined';

    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      tertiary: accent,
      onTertiary: Colors.white,
      surface: surface,
      onSurface: text,
      surfaceContainerHighest: textMuted.withValues(alpha: 0.12),
      error: const Color(0xFFB3261E),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: bodyFont,
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: headingFont, color: text),
        displayMedium: TextStyle(fontFamily: headingFont, color: text),
        headlineSmall: TextStyle(fontFamily: headingFont, color: text),
        titleLarge: TextStyle(fontFamily: headingFont, color: text),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text),
        bodySmall: TextStyle(color: textMuted),
        labelSmall: TextStyle(color: textMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: cardElevated ? 2 : 0,
        margin: EdgeInsets.all(comfortable ? 8 : 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: cardElevated
              ? BorderSide.none
              : BorderSide(color: textMuted.withValues(alpha: 0.3)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: accent.withValues(alpha: 0.15),
        labelStyle: TextStyle(color: text),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      dividerColor: textMuted.withValues(alpha: 0.25),
    );
  }
}
