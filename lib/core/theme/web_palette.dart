import 'package:flutter/material.dart';

/// Web-derived constants (mirrors `order-menu.tsx` CSS, NOT server-driven).
/// Controlled theming policy holds: these are fixed brand neutrals, the same
/// for every tenant — only the tokens in [TenantThemeTokens] vary per tenant.
class WebPalette {
  const WebPalette._();

  /// 0.5px borders/dividers on cards, nav, section headers.
  static const Color hairline = Color(0xFFE4DDCF);

  /// Image placeholder wash behind dish photos.
  static const Color imageWash = Color(0xFFEDE7DB);

  /// Price text + order total (web `--accent-text: #9C7638`).
  static const Color accentText = Color(0xFF9C7638);

  /// Stepper outline.
  static const Color stepperBorder = Color(0xFFC9C0B2);

  /// Counter bar secondary texts (web hardcodes #B7BEC2 / #8C959A on primary).
  static const Color counterLabel = Color(0xFFB7BEC2);
  static const Color counterSub = Color(0xFF8C959A);

  /// Script display face for the hero title (Latin glyphs; Arabic falls back).
  static const String scriptFont = 'AlexBrush';
}
