import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/theme/tenant_theme_mapper.dart';

void main() {
  group('parseHex', () {
    test('3-digit, 6-digit, garbage', () {
      expect(
        TenantThemeMapper.parseHex('#fff', Colors.black),
        const Color(0xFFFFFFFF),
      );
      expect(
        TenantThemeMapper.parseHex('#e74c3c', Colors.black),
        const Color(0xFFE74C3C),
      );
      // Garbage never crashes — falls back.
      expect(
        TenantThemeMapper.parseHex('nope', Colors.black),
        Colors.black,
      );
      expect(
        TenantThemeMapper.parseHex('#12345', Colors.black),
        Colors.black,
      );
    });
  });

  group('parsePx', () {
    test('px suffix, garbage, negative and absurd clamp to fallback', () {
      expect(TenantThemeMapper.parsePx('4px', 8), 4);
      expect(TenantThemeMapper.parsePx('abc', 8), 8);
      expect(TenantThemeMapper.parsePx('-8px', 8), 8);
      expect(TenantThemeMapper.parsePx('9999px', 8), 8);
    });
  });

  group('mapFont', () {
    test('known families map, unknown falls back', () {
      expect(TenantThemeMapper.mapFont('Cairo', 'Inter'), 'Cairo');
      expect(TenantThemeMapper.mapFont('Georgia, serif', 'Inter'), 'Cairo');
      expect(TenantThemeMapper.mapFont('Wingdings', 'Inter'), 'Inter');
    });
  });
}
