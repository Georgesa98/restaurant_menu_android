/// Controlled design tokens mirrored from the web `Tenant` model
/// (docs/PLAN.md §2). `customCss` is deprecated by policy and NEVER read here.
class TenantThemeTokens {
  const TenantThemeTokens({
    this.primaryColor = '#e74c3c',
    this.secondaryColor = '#2c3e50',
    this.accentColor = '#f39c12',
    this.backgroundColor = '#fdf5e6',
    this.surfaceColor = '#ffffff',
    this.textColor = '#1a1a2e',
    this.textMuted = '#64748b',
    this.headingFont = 'Cairo',
    this.bodyFont = 'Inter',
    this.borderRadiusSm = '4px',
    this.borderRadiusMd = '8px',
    this.borderRadiusLg = '16px',
    this.cardStyle = 'elevated',
    this.menuLayout = 'single',
    this.spacing = 'comfortable',
    this.logoUrl,
    this.coverUrl,
  });

  factory TenantThemeTokens.fromJson(Map<String, dynamic> json) {
    String str(String key, String fallback) =>
        (json[key] as String?)?.trim().isNotEmpty == true
            ? (json[key] as String).trim()
            : fallback;
    return TenantThemeTokens(
      primaryColor: str('primaryColor', '#e74c3c'),
      secondaryColor: str('secondaryColor', '#2c3e50'),
      accentColor: str('accentColor', '#f39c12'),
      backgroundColor: str('backgroundColor', '#fdf5e6'),
      surfaceColor: str('surfaceColor', '#ffffff'),
      textColor: str('textColor', '#1a1a2e'),
      textMuted: str('textMuted', '#64748b'),
      headingFont: str('headingFont', 'Cairo'),
      bodyFont: str('bodyFont', 'Inter'),
      borderRadiusSm: str('borderRadiusSm', '4px'),
      borderRadiusMd: str('borderRadiusMd', '8px'),
      borderRadiusLg: str('borderRadiusLg', '16px'),
      cardStyle: str('cardStyle', 'elevated'),
      menuLayout: str('menuLayout', 'single'),
      spacing: str('spacing', 'comfortable'),
      logoUrl: json['logoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      // NOTE: json['customCss'] is intentionally ignored (policy).
    );
  }

  static const TenantThemeTokens defaults = TenantThemeTokens();
  final String primaryColor;
  final String secondaryColor;
  final String accentColor;
  final String backgroundColor;
  final String surfaceColor;
  final String textColor;
  final String textMuted;
  final String headingFont;
  final String bodyFont;
  final String borderRadiusSm;
  final String borderRadiusMd;
  final String borderRadiusLg;
  final String cardStyle;
  final String menuLayout;
  final String spacing;
  final String? logoUrl;
  final String? coverUrl;
}
