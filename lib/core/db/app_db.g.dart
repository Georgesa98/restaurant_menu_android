// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $TenantsTable extends Tenants with TableInfo<$TenantsTable, Tenant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('FREE'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _primaryColorMeta = const VerificationMeta(
    'primaryColor',
  );
  @override
  late final GeneratedColumn<String> primaryColor = GeneratedColumn<String>(
    'primary_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#e74c3c'),
  );
  static const VerificationMeta _secondaryColorMeta = const VerificationMeta(
    'secondaryColor',
  );
  @override
  late final GeneratedColumn<String> secondaryColor = GeneratedColumn<String>(
    'secondary_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#2c3e50'),
  );
  static const VerificationMeta _accentColorMeta = const VerificationMeta(
    'accentColor',
  );
  @override
  late final GeneratedColumn<String> accentColor = GeneratedColumn<String>(
    'accent_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#f39c12'),
  );
  static const VerificationMeta _backgroundColorMeta = const VerificationMeta(
    'backgroundColor',
  );
  @override
  late final GeneratedColumn<String> backgroundColor = GeneratedColumn<String>(
    'background_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#fdf5e6'),
  );
  static const VerificationMeta _surfaceColorMeta = const VerificationMeta(
    'surfaceColor',
  );
  @override
  late final GeneratedColumn<String> surfaceColor = GeneratedColumn<String>(
    'surface_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#ffffff'),
  );
  static const VerificationMeta _textColorMeta = const VerificationMeta(
    'textColor',
  );
  @override
  late final GeneratedColumn<String> textColor = GeneratedColumn<String>(
    'text_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#1a1a2e'),
  );
  static const VerificationMeta _textMutedMeta = const VerificationMeta(
    'textMuted',
  );
  @override
  late final GeneratedColumn<String> textMuted = GeneratedColumn<String>(
    'text_muted',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#64748b'),
  );
  static const VerificationMeta _headingFontMeta = const VerificationMeta(
    'headingFont',
  );
  @override
  late final GeneratedColumn<String> headingFont = GeneratedColumn<String>(
    'heading_font',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Cairo'),
  );
  static const VerificationMeta _bodyFontMeta = const VerificationMeta(
    'bodyFont',
  );
  @override
  late final GeneratedColumn<String> bodyFont = GeneratedColumn<String>(
    'body_font',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Inter'),
  );
  static const VerificationMeta _borderRadiusSmMeta = const VerificationMeta(
    'borderRadiusSm',
  );
  @override
  late final GeneratedColumn<String> borderRadiusSm = GeneratedColumn<String>(
    'border_radius_sm',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('4px'),
  );
  static const VerificationMeta _borderRadiusMdMeta = const VerificationMeta(
    'borderRadiusMd',
  );
  @override
  late final GeneratedColumn<String> borderRadiusMd = GeneratedColumn<String>(
    'border_radius_md',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('8px'),
  );
  static const VerificationMeta _borderRadiusLgMeta = const VerificationMeta(
    'borderRadiusLg',
  );
  @override
  late final GeneratedColumn<String> borderRadiusLg = GeneratedColumn<String>(
    'border_radius_lg',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('16px'),
  );
  static const VerificationMeta _cardStyleMeta = const VerificationMeta(
    'cardStyle',
  );
  @override
  late final GeneratedColumn<String> cardStyle = GeneratedColumn<String>(
    'card_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('elevated'),
  );
  static const VerificationMeta _menuLayoutMeta = const VerificationMeta(
    'menuLayout',
  );
  @override
  late final GeneratedColumn<String> menuLayout = GeneratedColumn<String>(
    'menu_layout',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('single'),
  );
  static const VerificationMeta _spacingMeta = const VerificationMeta(
    'spacing',
  );
  @override
  late final GeneratedColumn<String> spacing = GeneratedColumn<String>(
    'spacing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('comfortable'),
  );
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instagramMeta = const VerificationMeta(
    'instagram',
  );
  @override
  late final GeneratedColumn<String> instagram = GeneratedColumn<String>(
    'instagram',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultLocaleMeta = const VerificationMeta(
    'defaultLocale',
  );
  @override
  late final GeneratedColumn<String> defaultLocale = GeneratedColumn<String>(
    'default_locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ar'),
  );
  static const VerificationMeta _availableLocalesCsvMeta =
      const VerificationMeta('availableLocalesCsv');
  @override
  late final GeneratedColumn<String> availableLocalesCsv =
      GeneratedColumn<String>(
        'available_locales_csv',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('ar,en'),
      );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<String> lastSyncAt = GeneratedColumn<String>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    slug,
    plan,
    isActive,
    primaryColor,
    secondaryColor,
    accentColor,
    backgroundColor,
    surfaceColor,
    textColor,
    textMuted,
    headingFont,
    bodyFont,
    borderRadiusSm,
    borderRadiusMd,
    borderRadiusLg,
    cardStyle,
    menuLayout,
    spacing,
    logoUrl,
    coverUrl,
    description,
    address,
    phone,
    instagram,
    website,
    defaultLocale,
    availableLocalesCsv,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tenant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('primary_color')) {
      context.handle(
        _primaryColorMeta,
        primaryColor.isAcceptableOrUnknown(
          data['primary_color']!,
          _primaryColorMeta,
        ),
      );
    }
    if (data.containsKey('secondary_color')) {
      context.handle(
        _secondaryColorMeta,
        secondaryColor.isAcceptableOrUnknown(
          data['secondary_color']!,
          _secondaryColorMeta,
        ),
      );
    }
    if (data.containsKey('accent_color')) {
      context.handle(
        _accentColorMeta,
        accentColor.isAcceptableOrUnknown(
          data['accent_color']!,
          _accentColorMeta,
        ),
      );
    }
    if (data.containsKey('background_color')) {
      context.handle(
        _backgroundColorMeta,
        backgroundColor.isAcceptableOrUnknown(
          data['background_color']!,
          _backgroundColorMeta,
        ),
      );
    }
    if (data.containsKey('surface_color')) {
      context.handle(
        _surfaceColorMeta,
        surfaceColor.isAcceptableOrUnknown(
          data['surface_color']!,
          _surfaceColorMeta,
        ),
      );
    }
    if (data.containsKey('text_color')) {
      context.handle(
        _textColorMeta,
        textColor.isAcceptableOrUnknown(data['text_color']!, _textColorMeta),
      );
    }
    if (data.containsKey('text_muted')) {
      context.handle(
        _textMutedMeta,
        textMuted.isAcceptableOrUnknown(data['text_muted']!, _textMutedMeta),
      );
    }
    if (data.containsKey('heading_font')) {
      context.handle(
        _headingFontMeta,
        headingFont.isAcceptableOrUnknown(
          data['heading_font']!,
          _headingFontMeta,
        ),
      );
    }
    if (data.containsKey('body_font')) {
      context.handle(
        _bodyFontMeta,
        bodyFont.isAcceptableOrUnknown(data['body_font']!, _bodyFontMeta),
      );
    }
    if (data.containsKey('border_radius_sm')) {
      context.handle(
        _borderRadiusSmMeta,
        borderRadiusSm.isAcceptableOrUnknown(
          data['border_radius_sm']!,
          _borderRadiusSmMeta,
        ),
      );
    }
    if (data.containsKey('border_radius_md')) {
      context.handle(
        _borderRadiusMdMeta,
        borderRadiusMd.isAcceptableOrUnknown(
          data['border_radius_md']!,
          _borderRadiusMdMeta,
        ),
      );
    }
    if (data.containsKey('border_radius_lg')) {
      context.handle(
        _borderRadiusLgMeta,
        borderRadiusLg.isAcceptableOrUnknown(
          data['border_radius_lg']!,
          _borderRadiusLgMeta,
        ),
      );
    }
    if (data.containsKey('card_style')) {
      context.handle(
        _cardStyleMeta,
        cardStyle.isAcceptableOrUnknown(data['card_style']!, _cardStyleMeta),
      );
    }
    if (data.containsKey('menu_layout')) {
      context.handle(
        _menuLayoutMeta,
        menuLayout.isAcceptableOrUnknown(data['menu_layout']!, _menuLayoutMeta),
      );
    }
    if (data.containsKey('spacing')) {
      context.handle(
        _spacingMeta,
        spacing.isAcceptableOrUnknown(data['spacing']!, _spacingMeta),
      );
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('instagram')) {
      context.handle(
        _instagramMeta,
        instagram.isAcceptableOrUnknown(data['instagram']!, _instagramMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('default_locale')) {
      context.handle(
        _defaultLocaleMeta,
        defaultLocale.isAcceptableOrUnknown(
          data['default_locale']!,
          _defaultLocaleMeta,
        ),
      );
    }
    if (data.containsKey('available_locales_csv')) {
      context.handle(
        _availableLocalesCsvMeta,
        availableLocalesCsv.isAcceptableOrUnknown(
          data['available_locales_csv']!,
          _availableLocalesCsvMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tenant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tenant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      primaryColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_color'],
      )!,
      secondaryColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_color'],
      )!,
      accentColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_color'],
      )!,
      backgroundColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_color'],
      )!,
      surfaceColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surface_color'],
      )!,
      textColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_color'],
      )!,
      textMuted: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_muted'],
      )!,
      headingFont: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}heading_font'],
      )!,
      bodyFont: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_font'],
      )!,
      borderRadiusSm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}border_radius_sm'],
      )!,
      borderRadiusMd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}border_radius_md'],
      )!,
      borderRadiusLg: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}border_radius_lg'],
      )!,
      cardStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_style'],
      )!,
      menuLayout: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}menu_layout'],
      )!,
      spacing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spacing'],
      )!,
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      instagram: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instagram'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      defaultLocale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_locale'],
      )!,
      availableLocalesCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_locales_csv'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $TenantsTable createAlias(String alias) {
    return $TenantsTable(attachedDatabase, alias);
  }
}

class Tenant extends DataClass implements Insertable<Tenant> {
  final String id;
  final String name;
  final String slug;
  final String plan;
  final bool isActive;
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
  final String? description;
  final String? address;
  final String? phone;
  final String? instagram;
  final String? website;
  final String defaultLocale;
  final String availableLocalesCsv;
  final String? lastSyncAt;
  const Tenant({
    required this.id,
    required this.name,
    required this.slug,
    required this.plan,
    required this.isActive,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.textMuted,
    required this.headingFont,
    required this.bodyFont,
    required this.borderRadiusSm,
    required this.borderRadiusMd,
    required this.borderRadiusLg,
    required this.cardStyle,
    required this.menuLayout,
    required this.spacing,
    this.logoUrl,
    this.coverUrl,
    this.description,
    this.address,
    this.phone,
    this.instagram,
    this.website,
    required this.defaultLocale,
    required this.availableLocalesCsv,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['plan'] = Variable<String>(plan);
    map['is_active'] = Variable<bool>(isActive);
    map['primary_color'] = Variable<String>(primaryColor);
    map['secondary_color'] = Variable<String>(secondaryColor);
    map['accent_color'] = Variable<String>(accentColor);
    map['background_color'] = Variable<String>(backgroundColor);
    map['surface_color'] = Variable<String>(surfaceColor);
    map['text_color'] = Variable<String>(textColor);
    map['text_muted'] = Variable<String>(textMuted);
    map['heading_font'] = Variable<String>(headingFont);
    map['body_font'] = Variable<String>(bodyFont);
    map['border_radius_sm'] = Variable<String>(borderRadiusSm);
    map['border_radius_md'] = Variable<String>(borderRadiusMd);
    map['border_radius_lg'] = Variable<String>(borderRadiusLg);
    map['card_style'] = Variable<String>(cardStyle);
    map['menu_layout'] = Variable<String>(menuLayout);
    map['spacing'] = Variable<String>(spacing);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || instagram != null) {
      map['instagram'] = Variable<String>(instagram);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    map['default_locale'] = Variable<String>(defaultLocale);
    map['available_locales_csv'] = Variable<String>(availableLocalesCsv);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<String>(lastSyncAt);
    }
    return map;
  }

  TenantsCompanion toCompanion(bool nullToAbsent) {
    return TenantsCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      plan: Value(plan),
      isActive: Value(isActive),
      primaryColor: Value(primaryColor),
      secondaryColor: Value(secondaryColor),
      accentColor: Value(accentColor),
      backgroundColor: Value(backgroundColor),
      surfaceColor: Value(surfaceColor),
      textColor: Value(textColor),
      textMuted: Value(textMuted),
      headingFont: Value(headingFont),
      bodyFont: Value(bodyFont),
      borderRadiusSm: Value(borderRadiusSm),
      borderRadiusMd: Value(borderRadiusMd),
      borderRadiusLg: Value(borderRadiusLg),
      cardStyle: Value(cardStyle),
      menuLayout: Value(menuLayout),
      spacing: Value(spacing),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      instagram: instagram == null && nullToAbsent
          ? const Value.absent()
          : Value(instagram),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      defaultLocale: Value(defaultLocale),
      availableLocalesCsv: Value(availableLocalesCsv),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory Tenant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tenant(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      plan: serializer.fromJson<String>(json['plan']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      primaryColor: serializer.fromJson<String>(json['primaryColor']),
      secondaryColor: serializer.fromJson<String>(json['secondaryColor']),
      accentColor: serializer.fromJson<String>(json['accentColor']),
      backgroundColor: serializer.fromJson<String>(json['backgroundColor']),
      surfaceColor: serializer.fromJson<String>(json['surfaceColor']),
      textColor: serializer.fromJson<String>(json['textColor']),
      textMuted: serializer.fromJson<String>(json['textMuted']),
      headingFont: serializer.fromJson<String>(json['headingFont']),
      bodyFont: serializer.fromJson<String>(json['bodyFont']),
      borderRadiusSm: serializer.fromJson<String>(json['borderRadiusSm']),
      borderRadiusMd: serializer.fromJson<String>(json['borderRadiusMd']),
      borderRadiusLg: serializer.fromJson<String>(json['borderRadiusLg']),
      cardStyle: serializer.fromJson<String>(json['cardStyle']),
      menuLayout: serializer.fromJson<String>(json['menuLayout']),
      spacing: serializer.fromJson<String>(json['spacing']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      description: serializer.fromJson<String?>(json['description']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      instagram: serializer.fromJson<String?>(json['instagram']),
      website: serializer.fromJson<String?>(json['website']),
      defaultLocale: serializer.fromJson<String>(json['defaultLocale']),
      availableLocalesCsv: serializer.fromJson<String>(
        json['availableLocalesCsv'],
      ),
      lastSyncAt: serializer.fromJson<String?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'plan': serializer.toJson<String>(plan),
      'isActive': serializer.toJson<bool>(isActive),
      'primaryColor': serializer.toJson<String>(primaryColor),
      'secondaryColor': serializer.toJson<String>(secondaryColor),
      'accentColor': serializer.toJson<String>(accentColor),
      'backgroundColor': serializer.toJson<String>(backgroundColor),
      'surfaceColor': serializer.toJson<String>(surfaceColor),
      'textColor': serializer.toJson<String>(textColor),
      'textMuted': serializer.toJson<String>(textMuted),
      'headingFont': serializer.toJson<String>(headingFont),
      'bodyFont': serializer.toJson<String>(bodyFont),
      'borderRadiusSm': serializer.toJson<String>(borderRadiusSm),
      'borderRadiusMd': serializer.toJson<String>(borderRadiusMd),
      'borderRadiusLg': serializer.toJson<String>(borderRadiusLg),
      'cardStyle': serializer.toJson<String>(cardStyle),
      'menuLayout': serializer.toJson<String>(menuLayout),
      'spacing': serializer.toJson<String>(spacing),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'description': serializer.toJson<String?>(description),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'instagram': serializer.toJson<String?>(instagram),
      'website': serializer.toJson<String?>(website),
      'defaultLocale': serializer.toJson<String>(defaultLocale),
      'availableLocalesCsv': serializer.toJson<String>(availableLocalesCsv),
      'lastSyncAt': serializer.toJson<String?>(lastSyncAt),
    };
  }

  Tenant copyWith({
    String? id,
    String? name,
    String? slug,
    String? plan,
    bool? isActive,
    String? primaryColor,
    String? secondaryColor,
    String? accentColor,
    String? backgroundColor,
    String? surfaceColor,
    String? textColor,
    String? textMuted,
    String? headingFont,
    String? bodyFont,
    String? borderRadiusSm,
    String? borderRadiusMd,
    String? borderRadiusLg,
    String? cardStyle,
    String? menuLayout,
    String? spacing,
    Value<String?> logoUrl = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> instagram = const Value.absent(),
    Value<String?> website = const Value.absent(),
    String? defaultLocale,
    String? availableLocalesCsv,
    Value<String?> lastSyncAt = const Value.absent(),
  }) => Tenant(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    plan: plan ?? this.plan,
    isActive: isActive ?? this.isActive,
    primaryColor: primaryColor ?? this.primaryColor,
    secondaryColor: secondaryColor ?? this.secondaryColor,
    accentColor: accentColor ?? this.accentColor,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    surfaceColor: surfaceColor ?? this.surfaceColor,
    textColor: textColor ?? this.textColor,
    textMuted: textMuted ?? this.textMuted,
    headingFont: headingFont ?? this.headingFont,
    bodyFont: bodyFont ?? this.bodyFont,
    borderRadiusSm: borderRadiusSm ?? this.borderRadiusSm,
    borderRadiusMd: borderRadiusMd ?? this.borderRadiusMd,
    borderRadiusLg: borderRadiusLg ?? this.borderRadiusLg,
    cardStyle: cardStyle ?? this.cardStyle,
    menuLayout: menuLayout ?? this.menuLayout,
    spacing: spacing ?? this.spacing,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    description: description.present ? description.value : this.description,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    instagram: instagram.present ? instagram.value : this.instagram,
    website: website.present ? website.value : this.website,
    defaultLocale: defaultLocale ?? this.defaultLocale,
    availableLocalesCsv: availableLocalesCsv ?? this.availableLocalesCsv,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  Tenant copyWithCompanion(TenantsCompanion data) {
    return Tenant(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      plan: data.plan.present ? data.plan.value : this.plan,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      primaryColor: data.primaryColor.present
          ? data.primaryColor.value
          : this.primaryColor,
      secondaryColor: data.secondaryColor.present
          ? data.secondaryColor.value
          : this.secondaryColor,
      accentColor: data.accentColor.present
          ? data.accentColor.value
          : this.accentColor,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      surfaceColor: data.surfaceColor.present
          ? data.surfaceColor.value
          : this.surfaceColor,
      textColor: data.textColor.present ? data.textColor.value : this.textColor,
      textMuted: data.textMuted.present ? data.textMuted.value : this.textMuted,
      headingFont: data.headingFont.present
          ? data.headingFont.value
          : this.headingFont,
      bodyFont: data.bodyFont.present ? data.bodyFont.value : this.bodyFont,
      borderRadiusSm: data.borderRadiusSm.present
          ? data.borderRadiusSm.value
          : this.borderRadiusSm,
      borderRadiusMd: data.borderRadiusMd.present
          ? data.borderRadiusMd.value
          : this.borderRadiusMd,
      borderRadiusLg: data.borderRadiusLg.present
          ? data.borderRadiusLg.value
          : this.borderRadiusLg,
      cardStyle: data.cardStyle.present ? data.cardStyle.value : this.cardStyle,
      menuLayout: data.menuLayout.present
          ? data.menuLayout.value
          : this.menuLayout,
      spacing: data.spacing.present ? data.spacing.value : this.spacing,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      description: data.description.present
          ? data.description.value
          : this.description,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      instagram: data.instagram.present ? data.instagram.value : this.instagram,
      website: data.website.present ? data.website.value : this.website,
      defaultLocale: data.defaultLocale.present
          ? data.defaultLocale.value
          : this.defaultLocale,
      availableLocalesCsv: data.availableLocalesCsv.present
          ? data.availableLocalesCsv.value
          : this.availableLocalesCsv,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tenant(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('plan: $plan, ')
          ..write('isActive: $isActive, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('accentColor: $accentColor, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('surfaceColor: $surfaceColor, ')
          ..write('textColor: $textColor, ')
          ..write('textMuted: $textMuted, ')
          ..write('headingFont: $headingFont, ')
          ..write('bodyFont: $bodyFont, ')
          ..write('borderRadiusSm: $borderRadiusSm, ')
          ..write('borderRadiusMd: $borderRadiusMd, ')
          ..write('borderRadiusLg: $borderRadiusLg, ')
          ..write('cardStyle: $cardStyle, ')
          ..write('menuLayout: $menuLayout, ')
          ..write('spacing: $spacing, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('instagram: $instagram, ')
          ..write('website: $website, ')
          ..write('defaultLocale: $defaultLocale, ')
          ..write('availableLocalesCsv: $availableLocalesCsv, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    slug,
    plan,
    isActive,
    primaryColor,
    secondaryColor,
    accentColor,
    backgroundColor,
    surfaceColor,
    textColor,
    textMuted,
    headingFont,
    bodyFont,
    borderRadiusSm,
    borderRadiusMd,
    borderRadiusLg,
    cardStyle,
    menuLayout,
    spacing,
    logoUrl,
    coverUrl,
    description,
    address,
    phone,
    instagram,
    website,
    defaultLocale,
    availableLocalesCsv,
    lastSyncAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tenant &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.plan == this.plan &&
          other.isActive == this.isActive &&
          other.primaryColor == this.primaryColor &&
          other.secondaryColor == this.secondaryColor &&
          other.accentColor == this.accentColor &&
          other.backgroundColor == this.backgroundColor &&
          other.surfaceColor == this.surfaceColor &&
          other.textColor == this.textColor &&
          other.textMuted == this.textMuted &&
          other.headingFont == this.headingFont &&
          other.bodyFont == this.bodyFont &&
          other.borderRadiusSm == this.borderRadiusSm &&
          other.borderRadiusMd == this.borderRadiusMd &&
          other.borderRadiusLg == this.borderRadiusLg &&
          other.cardStyle == this.cardStyle &&
          other.menuLayout == this.menuLayout &&
          other.spacing == this.spacing &&
          other.logoUrl == this.logoUrl &&
          other.coverUrl == this.coverUrl &&
          other.description == this.description &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.instagram == this.instagram &&
          other.website == this.website &&
          other.defaultLocale == this.defaultLocale &&
          other.availableLocalesCsv == this.availableLocalesCsv &&
          other.lastSyncAt == this.lastSyncAt);
}

class TenantsCompanion extends UpdateCompanion<Tenant> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> plan;
  final Value<bool> isActive;
  final Value<String> primaryColor;
  final Value<String> secondaryColor;
  final Value<String> accentColor;
  final Value<String> backgroundColor;
  final Value<String> surfaceColor;
  final Value<String> textColor;
  final Value<String> textMuted;
  final Value<String> headingFont;
  final Value<String> bodyFont;
  final Value<String> borderRadiusSm;
  final Value<String> borderRadiusMd;
  final Value<String> borderRadiusLg;
  final Value<String> cardStyle;
  final Value<String> menuLayout;
  final Value<String> spacing;
  final Value<String?> logoUrl;
  final Value<String?> coverUrl;
  final Value<String?> description;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> instagram;
  final Value<String?> website;
  final Value<String> defaultLocale;
  final Value<String> availableLocalesCsv;
  final Value<String?> lastSyncAt;
  final Value<int> rowid;
  const TenantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.plan = const Value.absent(),
    this.isActive = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.secondaryColor = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.surfaceColor = const Value.absent(),
    this.textColor = const Value.absent(),
    this.textMuted = const Value.absent(),
    this.headingFont = const Value.absent(),
    this.bodyFont = const Value.absent(),
    this.borderRadiusSm = const Value.absent(),
    this.borderRadiusMd = const Value.absent(),
    this.borderRadiusLg = const Value.absent(),
    this.cardStyle = const Value.absent(),
    this.menuLayout = const Value.absent(),
    this.spacing = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.instagram = const Value.absent(),
    this.website = const Value.absent(),
    this.defaultLocale = const Value.absent(),
    this.availableLocalesCsv = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantsCompanion.insert({
    required String id,
    required String name,
    required String slug,
    this.plan = const Value.absent(),
    this.isActive = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.secondaryColor = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.surfaceColor = const Value.absent(),
    this.textColor = const Value.absent(),
    this.textMuted = const Value.absent(),
    this.headingFont = const Value.absent(),
    this.bodyFont = const Value.absent(),
    this.borderRadiusSm = const Value.absent(),
    this.borderRadiusMd = const Value.absent(),
    this.borderRadiusLg = const Value.absent(),
    this.cardStyle = const Value.absent(),
    this.menuLayout = const Value.absent(),
    this.spacing = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.instagram = const Value.absent(),
    this.website = const Value.absent(),
    this.defaultLocale = const Value.absent(),
    this.availableLocalesCsv = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       slug = Value(slug);
  static Insertable<Tenant> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? plan,
    Expression<bool>? isActive,
    Expression<String>? primaryColor,
    Expression<String>? secondaryColor,
    Expression<String>? accentColor,
    Expression<String>? backgroundColor,
    Expression<String>? surfaceColor,
    Expression<String>? textColor,
    Expression<String>? textMuted,
    Expression<String>? headingFont,
    Expression<String>? bodyFont,
    Expression<String>? borderRadiusSm,
    Expression<String>? borderRadiusMd,
    Expression<String>? borderRadiusLg,
    Expression<String>? cardStyle,
    Expression<String>? menuLayout,
    Expression<String>? spacing,
    Expression<String>? logoUrl,
    Expression<String>? coverUrl,
    Expression<String>? description,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? instagram,
    Expression<String>? website,
    Expression<String>? defaultLocale,
    Expression<String>? availableLocalesCsv,
    Expression<String>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (plan != null) 'plan': plan,
      if (isActive != null) 'is_active': isActive,
      if (primaryColor != null) 'primary_color': primaryColor,
      if (secondaryColor != null) 'secondary_color': secondaryColor,
      if (accentColor != null) 'accent_color': accentColor,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (surfaceColor != null) 'surface_color': surfaceColor,
      if (textColor != null) 'text_color': textColor,
      if (textMuted != null) 'text_muted': textMuted,
      if (headingFont != null) 'heading_font': headingFont,
      if (bodyFont != null) 'body_font': bodyFont,
      if (borderRadiusSm != null) 'border_radius_sm': borderRadiusSm,
      if (borderRadiusMd != null) 'border_radius_md': borderRadiusMd,
      if (borderRadiusLg != null) 'border_radius_lg': borderRadiusLg,
      if (cardStyle != null) 'card_style': cardStyle,
      if (menuLayout != null) 'menu_layout': menuLayout,
      if (spacing != null) 'spacing': spacing,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (instagram != null) 'instagram': instagram,
      if (website != null) 'website': website,
      if (defaultLocale != null) 'default_locale': defaultLocale,
      if (availableLocalesCsv != null)
        'available_locales_csv': availableLocalesCsv,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? slug,
    Value<String>? plan,
    Value<bool>? isActive,
    Value<String>? primaryColor,
    Value<String>? secondaryColor,
    Value<String>? accentColor,
    Value<String>? backgroundColor,
    Value<String>? surfaceColor,
    Value<String>? textColor,
    Value<String>? textMuted,
    Value<String>? headingFont,
    Value<String>? bodyFont,
    Value<String>? borderRadiusSm,
    Value<String>? borderRadiusMd,
    Value<String>? borderRadiusLg,
    Value<String>? cardStyle,
    Value<String>? menuLayout,
    Value<String>? spacing,
    Value<String?>? logoUrl,
    Value<String?>? coverUrl,
    Value<String?>? description,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? instagram,
    Value<String?>? website,
    Value<String>? defaultLocale,
    Value<String>? availableLocalesCsv,
    Value<String?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return TenantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      plan: plan ?? this.plan,
      isActive: isActive ?? this.isActive,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      textMuted: textMuted ?? this.textMuted,
      headingFont: headingFont ?? this.headingFont,
      bodyFont: bodyFont ?? this.bodyFont,
      borderRadiusSm: borderRadiusSm ?? this.borderRadiusSm,
      borderRadiusMd: borderRadiusMd ?? this.borderRadiusMd,
      borderRadiusLg: borderRadiusLg ?? this.borderRadiusLg,
      cardStyle: cardStyle ?? this.cardStyle,
      menuLayout: menuLayout ?? this.menuLayout,
      spacing: spacing ?? this.spacing,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      instagram: instagram ?? this.instagram,
      website: website ?? this.website,
      defaultLocale: defaultLocale ?? this.defaultLocale,
      availableLocalesCsv: availableLocalesCsv ?? this.availableLocalesCsv,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (primaryColor.present) {
      map['primary_color'] = Variable<String>(primaryColor.value);
    }
    if (secondaryColor.present) {
      map['secondary_color'] = Variable<String>(secondaryColor.value);
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<String>(accentColor.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<String>(backgroundColor.value);
    }
    if (surfaceColor.present) {
      map['surface_color'] = Variable<String>(surfaceColor.value);
    }
    if (textColor.present) {
      map['text_color'] = Variable<String>(textColor.value);
    }
    if (textMuted.present) {
      map['text_muted'] = Variable<String>(textMuted.value);
    }
    if (headingFont.present) {
      map['heading_font'] = Variable<String>(headingFont.value);
    }
    if (bodyFont.present) {
      map['body_font'] = Variable<String>(bodyFont.value);
    }
    if (borderRadiusSm.present) {
      map['border_radius_sm'] = Variable<String>(borderRadiusSm.value);
    }
    if (borderRadiusMd.present) {
      map['border_radius_md'] = Variable<String>(borderRadiusMd.value);
    }
    if (borderRadiusLg.present) {
      map['border_radius_lg'] = Variable<String>(borderRadiusLg.value);
    }
    if (cardStyle.present) {
      map['card_style'] = Variable<String>(cardStyle.value);
    }
    if (menuLayout.present) {
      map['menu_layout'] = Variable<String>(menuLayout.value);
    }
    if (spacing.present) {
      map['spacing'] = Variable<String>(spacing.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (instagram.present) {
      map['instagram'] = Variable<String>(instagram.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (defaultLocale.present) {
      map['default_locale'] = Variable<String>(defaultLocale.value);
    }
    if (availableLocalesCsv.present) {
      map['available_locales_csv'] = Variable<String>(
        availableLocalesCsv.value,
      );
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<String>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('plan: $plan, ')
          ..write('isActive: $isActive, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('accentColor: $accentColor, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('surfaceColor: $surfaceColor, ')
          ..write('textColor: $textColor, ')
          ..write('textMuted: $textMuted, ')
          ..write('headingFont: $headingFont, ')
          ..write('bodyFont: $bodyFont, ')
          ..write('borderRadiusSm: $borderRadiusSm, ')
          ..write('borderRadiusMd: $borderRadiusMd, ')
          ..write('borderRadiusLg: $borderRadiusLg, ')
          ..write('cardStyle: $cardStyle, ')
          ..write('menuLayout: $menuLayout, ')
          ..write('spacing: $spacing, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('instagram: $instagram, ')
          ..write('website: $website, ')
          ..write('defaultLocale: $defaultLocale, ')
          ..write('availableLocalesCsv: $availableLocalesCsv, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    name,
    slug,
    description,
    displayOrder,
    isActive,
    updatedAt,
    isDeleted,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String tenantId;
  final String name;
  final String slug;
  final String? description;
  final int displayOrder;
  final bool isActive;
  final String updatedAt;
  final bool isDeleted;
  final bool dirty;
  const Category({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.slug,
    this.description,
    required this.displayOrder,
    required this.isActive,
    required this.updatedAt,
    required this.isDeleted,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<String>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      name: Value(name),
      slug: Value(slug),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      displayOrder: Value(displayOrder),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      dirty: Value(dirty),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String?>(description),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  Category copyWith({
    String? id,
    String? tenantId,
    String? name,
    String? slug,
    Value<String?> description = const Value.absent(),
    int? displayOrder,
    bool? isActive,
    String? updatedAt,
    bool? isDeleted,
    bool? dirty,
  }) => Category(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    description: description.present ? description.value : this.description,
    displayOrder: displayOrder ?? this.displayOrder,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    dirty: dirty ?? this.dirty,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      description: data.description.present
          ? data.description.value
          : this.description,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    name,
    slug,
    description,
    displayOrder,
    isActive,
    updatedAt,
    isDeleted,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.displayOrder == this.displayOrder &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.dirty == this.dirty);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> name;
  final Value<String> slug;
  final Value<String?> description;
  final Value<int> displayOrder;
  final Value<bool> isActive;
  final Value<String> updatedAt;
  final Value<bool> isDeleted;
  final Value<bool> dirty;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String tenantId,
    required String name,
    required String slug,
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    required String updatedAt,
    this.isDeleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       name = Value(name),
       slug = Value(slug),
       updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<int>? displayOrder,
    Expression<bool>? isActive,
    Expression<String>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? name,
    Value<String>? slug,
    Value<String?>? description,
    Value<int>? displayOrder,
    Value<bool>? isActive,
    Value<String>? updatedAt,
    Value<bool>? isDeleted,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryTranslationsTable extends CategoryTranslations
    with TableInfo<$CategoryTranslationsTable, CategoryTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    categoryId,
    locale,
    name,
    description,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId, locale};
  @override
  CategoryTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryTranslation(
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $CategoryTranslationsTable createAlias(String alias) {
    return $CategoryTranslationsTable(attachedDatabase, alias);
  }
}

class CategoryTranslation extends DataClass
    implements Insertable<CategoryTranslation> {
  final String categoryId;
  final String locale;
  final String name;
  final String? description;
  final bool dirty;
  const CategoryTranslation({
    required this.categoryId,
    required this.locale,
    required this.name,
    this.description,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<String>(categoryId);
    map['locale'] = Variable<String>(locale);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  CategoryTranslationsCompanion toCompanion(bool nullToAbsent) {
    return CategoryTranslationsCompanion(
      categoryId: Value(categoryId),
      locale: Value(locale),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dirty: Value(dirty),
    );
  }

  factory CategoryTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryTranslation(
      categoryId: serializer.fromJson<String>(json['categoryId']),
      locale: serializer.fromJson<String>(json['locale']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<String>(categoryId),
      'locale': serializer.toJson<String>(locale),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  CategoryTranslation copyWith({
    String? categoryId,
    String? locale,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? dirty,
  }) => CategoryTranslation(
    categoryId: categoryId ?? this.categoryId,
    locale: locale ?? this.locale,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    dirty: dirty ?? this.dirty,
  );
  CategoryTranslation copyWithCompanion(CategoryTranslationsCompanion data) {
    return CategoryTranslation(
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      locale: data.locale.present ? data.locale.value : this.locale,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTranslation(')
          ..write('categoryId: $categoryId, ')
          ..write('locale: $locale, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoryId, locale, name, description, dirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTranslation &&
          other.categoryId == this.categoryId &&
          other.locale == this.locale &&
          other.name == this.name &&
          other.description == this.description &&
          other.dirty == this.dirty);
}

class CategoryTranslationsCompanion
    extends UpdateCompanion<CategoryTranslation> {
  final Value<String> categoryId;
  final Value<String> locale;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> dirty;
  final Value<int> rowid;
  const CategoryTranslationsCompanion({
    this.categoryId = const Value.absent(),
    this.locale = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryTranslationsCompanion.insert({
    required String categoryId,
    required String locale,
    required String name,
    this.description = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : categoryId = Value(categoryId),
       locale = Value(locale),
       name = Value(name);
  static Insertable<CategoryTranslation> custom({
    Expression<String>? categoryId,
    Expression<String>? locale,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (locale != null) 'locale': locale,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryTranslationsCompanion copyWith({
    Value<String>? categoryId,
    Value<String>? locale,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return CategoryTranslationsCompanion(
      categoryId: categoryId ?? this.categoryId,
      locale: locale ?? this.locale,
      name: name ?? this.name,
      description: description ?? this.description,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTranslationsCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('locale: $locale, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MenuItemsTable extends MenuItems
    with TableInfo<$MenuItemsTable, MenuItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _basePriceMeta = const VerificationMeta(
    'basePrice',
  );
  @override
  late final GeneratedColumn<double> basePrice = GeneratedColumn<double>(
    'base_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dietaryTagsCsvMeta = const VerificationMeta(
    'dietaryTagsCsv',
  );
  @override
  late final GeneratedColumn<String> dietaryTagsCsv = GeneratedColumn<String>(
    'dietary_tags_csv',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    categoryId,
    name,
    description,
    basePrice,
    imageUrl,
    isAvailable,
    displayOrder,
    dietaryTagsCsv,
    updatedAt,
    isDeleted,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenuItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('base_price')) {
      context.handle(
        _basePriceMeta,
        basePrice.isAcceptableOrUnknown(data['base_price']!, _basePriceMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('dietary_tags_csv')) {
      context.handle(
        _dietaryTagsCsvMeta,
        dietaryTagsCsv.isAcceptableOrUnknown(
          data['dietary_tags_csv']!,
          _dietaryTagsCsvMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      basePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_price'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      dietaryTagsCsv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dietary_tags_csv'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $MenuItemsTable createAlias(String alias) {
    return $MenuItemsTable(attachedDatabase, alias);
  }
}

class MenuItem extends DataClass implements Insertable<MenuItem> {
  final String id;
  final String tenantId;
  final String categoryId;
  final String name;
  final String? description;
  final double? basePrice;
  final String? imageUrl;
  final bool isAvailable;
  final int displayOrder;
  final String dietaryTagsCsv;
  final String updatedAt;
  final bool isDeleted;
  final bool dirty;
  const MenuItem({
    required this.id,
    required this.tenantId,
    required this.categoryId,
    required this.name,
    this.description,
    this.basePrice,
    this.imageUrl,
    required this.isAvailable,
    required this.displayOrder,
    required this.dietaryTagsCsv,
    required this.updatedAt,
    required this.isDeleted,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<String>(tenantId);
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || basePrice != null) {
      map['base_price'] = Variable<double>(basePrice);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    map['display_order'] = Variable<int>(displayOrder);
    map['dietary_tags_csv'] = Variable<String>(dietaryTagsCsv);
    map['updated_at'] = Variable<String>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  MenuItemsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      categoryId: Value(categoryId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      basePrice: basePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(basePrice),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isAvailable: Value(isAvailable),
      displayOrder: Value(displayOrder),
      dietaryTagsCsv: Value(dietaryTagsCsv),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      dirty: Value(dirty),
    );
  }

  factory MenuItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItem(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<String>(json['tenantId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      basePrice: serializer.fromJson<double?>(json['basePrice']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      dietaryTagsCsv: serializer.fromJson<String>(json['dietaryTagsCsv']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<String>(tenantId),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'basePrice': serializer.toJson<double?>(basePrice),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'dietaryTagsCsv': serializer.toJson<String>(dietaryTagsCsv),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  MenuItem copyWith({
    String? id,
    String? tenantId,
    String? categoryId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<double?> basePrice = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    bool? isAvailable,
    int? displayOrder,
    String? dietaryTagsCsv,
    String? updatedAt,
    bool? isDeleted,
    bool? dirty,
  }) => MenuItem(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    basePrice: basePrice.present ? basePrice.value : this.basePrice,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isAvailable: isAvailable ?? this.isAvailable,
    displayOrder: displayOrder ?? this.displayOrder,
    dietaryTagsCsv: dietaryTagsCsv ?? this.dietaryTagsCsv,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    dirty: dirty ?? this.dirty,
  );
  MenuItem copyWithCompanion(MenuItemsCompanion data) {
    return MenuItem(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      basePrice: data.basePrice.present ? data.basePrice.value : this.basePrice,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      dietaryTagsCsv: data.dietaryTagsCsv.present
          ? data.dietaryTagsCsv.value
          : this.dietaryTagsCsv,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItem(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('basePrice: $basePrice, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('dietaryTagsCsv: $dietaryTagsCsv, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    categoryId,
    name,
    description,
    basePrice,
    imageUrl,
    isAvailable,
    displayOrder,
    dietaryTagsCsv,
    updatedAt,
    isDeleted,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.basePrice == this.basePrice &&
          other.imageUrl == this.imageUrl &&
          other.isAvailable == this.isAvailable &&
          other.displayOrder == this.displayOrder &&
          other.dietaryTagsCsv == this.dietaryTagsCsv &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.dirty == this.dirty);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<String> id;
  final Value<String> tenantId;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<double?> basePrice;
  final Value<String?> imageUrl;
  final Value<bool> isAvailable;
  final Value<int> displayOrder;
  final Value<String> dietaryTagsCsv;
  final Value<String> updatedAt;
  final Value<bool> isDeleted;
  final Value<bool> dirty;
  final Value<int> rowid;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.dietaryTagsCsv = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    required String id,
    required String tenantId,
    required String categoryId,
    required String name,
    this.description = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.dietaryTagsCsv = const Value.absent(),
    required String updatedAt,
    this.isDeleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tenantId = Value(tenantId),
       categoryId = Value(categoryId),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<MenuItem> custom({
    Expression<String>? id,
    Expression<String>? tenantId,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? basePrice,
    Expression<String>? imageUrl,
    Expression<bool>? isAvailable,
    Expression<int>? displayOrder,
    Expression<String>? dietaryTagsCsv,
    Expression<String>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (basePrice != null) 'base_price': basePrice,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isAvailable != null) 'is_available': isAvailable,
      if (displayOrder != null) 'display_order': displayOrder,
      if (dietaryTagsCsv != null) 'dietary_tags_csv': dietaryTagsCsv,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenuItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? tenantId,
    Value<String>? categoryId,
    Value<String>? name,
    Value<String?>? description,
    Value<double?>? basePrice,
    Value<String?>? imageUrl,
    Value<bool>? isAvailable,
    Value<int>? displayOrder,
    Value<String>? dietaryTagsCsv,
    Value<String>? updatedAt,
    Value<bool>? isDeleted,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      displayOrder: displayOrder ?? this.displayOrder,
      dietaryTagsCsv: dietaryTagsCsv ?? this.dietaryTagsCsv,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (basePrice.present) {
      map['base_price'] = Variable<double>(basePrice.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (dietaryTagsCsv.present) {
      map['dietary_tags_csv'] = Variable<String>(dietaryTagsCsv.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('basePrice: $basePrice, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('dietaryTagsCsv: $dietaryTagsCsv, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MenuItemTranslationsTable extends MenuItemTranslations
    with TableInfo<$MenuItemTranslationsTable, MenuItemTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _menuItemIdMeta = const VerificationMeta(
    'menuItemId',
  );
  @override
  late final GeneratedColumn<String> menuItemId = GeneratedColumn<String>(
    'menu_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    menuItemId,
    locale,
    name,
    description,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_item_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenuItemTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('menu_item_id')) {
      context.handle(
        _menuItemIdMeta,
        menuItemId.isAcceptableOrUnknown(
          data['menu_item_id']!,
          _menuItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {menuItemId, locale};
  @override
  MenuItemTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItemTranslation(
      menuItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}menu_item_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $MenuItemTranslationsTable createAlias(String alias) {
    return $MenuItemTranslationsTable(attachedDatabase, alias);
  }
}

class MenuItemTranslation extends DataClass
    implements Insertable<MenuItemTranslation> {
  final String menuItemId;
  final String locale;
  final String name;
  final String? description;
  final bool dirty;
  const MenuItemTranslation({
    required this.menuItemId,
    required this.locale,
    required this.name,
    this.description,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['menu_item_id'] = Variable<String>(menuItemId);
    map['locale'] = Variable<String>(locale);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  MenuItemTranslationsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemTranslationsCompanion(
      menuItemId: Value(menuItemId),
      locale: Value(locale),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dirty: Value(dirty),
    );
  }

  factory MenuItemTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItemTranslation(
      menuItemId: serializer.fromJson<String>(json['menuItemId']),
      locale: serializer.fromJson<String>(json['locale']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'menuItemId': serializer.toJson<String>(menuItemId),
      'locale': serializer.toJson<String>(locale),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  MenuItemTranslation copyWith({
    String? menuItemId,
    String? locale,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? dirty,
  }) => MenuItemTranslation(
    menuItemId: menuItemId ?? this.menuItemId,
    locale: locale ?? this.locale,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    dirty: dirty ?? this.dirty,
  );
  MenuItemTranslation copyWithCompanion(MenuItemTranslationsCompanion data) {
    return MenuItemTranslation(
      menuItemId: data.menuItemId.present
          ? data.menuItemId.value
          : this.menuItemId,
      locale: data.locale.present ? data.locale.value : this.locale,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemTranslation(')
          ..write('menuItemId: $menuItemId, ')
          ..write('locale: $locale, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(menuItemId, locale, name, description, dirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItemTranslation &&
          other.menuItemId == this.menuItemId &&
          other.locale == this.locale &&
          other.name == this.name &&
          other.description == this.description &&
          other.dirty == this.dirty);
}

class MenuItemTranslationsCompanion
    extends UpdateCompanion<MenuItemTranslation> {
  final Value<String> menuItemId;
  final Value<String> locale;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> dirty;
  final Value<int> rowid;
  const MenuItemTranslationsCompanion({
    this.menuItemId = const Value.absent(),
    this.locale = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenuItemTranslationsCompanion.insert({
    required String menuItemId,
    required String locale,
    required String name,
    this.description = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : menuItemId = Value(menuItemId),
       locale = Value(locale),
       name = Value(name);
  static Insertable<MenuItemTranslation> custom({
    Expression<String>? menuItemId,
    Expression<String>? locale,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (locale != null) 'locale': locale,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenuItemTranslationsCompanion copyWith({
    Value<String>? menuItemId,
    Value<String>? locale,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return MenuItemTranslationsCompanion(
      menuItemId: menuItemId ?? this.menuItemId,
      locale: locale ?? this.locale,
      name: name ?? this.name,
      description: description ?? this.description,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<String>(menuItemId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemTranslationsCompanion(')
          ..write('menuItemId: $menuItemId, ')
          ..write('locale: $locale, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MenuItemVariantsTable extends MenuItemVariants
    with TableInfo<$MenuItemVariantsTable, MenuItemVariant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _menuItemIdMeta = const VerificationMeta(
    'menuItemId',
  );
  @override
  late final GeneratedColumn<String> menuItemId = GeneratedColumn<String>(
    'menu_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelEnMeta = const VerificationMeta(
    'labelEn',
  );
  @override
  late final GeneratedColumn<String> labelEn = GeneratedColumn<String>(
    'label_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    menuItemId,
    label,
    labelEn,
    price,
    sortOrder,
    isDeleted,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_item_variants';
  @override
  VerificationContext validateIntegrity(
    Insertable<MenuItemVariant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('menu_item_id')) {
      context.handle(
        _menuItemIdMeta,
        menuItemId.isAcceptableOrUnknown(
          data['menu_item_id']!,
          _menuItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('label_en')) {
      context.handle(
        _labelEnMeta,
        labelEn.isAcceptableOrUnknown(data['label_en']!, _labelEnMeta),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItemVariant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItemVariant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      menuItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}menu_item_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      labelEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_en'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $MenuItemVariantsTable createAlias(String alias) {
    return $MenuItemVariantsTable(attachedDatabase, alias);
  }
}

class MenuItemVariant extends DataClass implements Insertable<MenuItemVariant> {
  final String id;
  final String menuItemId;
  final String label;
  final String labelEn;
  final double price;
  final int sortOrder;
  final bool isDeleted;
  final bool dirty;
  const MenuItemVariant({
    required this.id,
    required this.menuItemId,
    required this.label,
    required this.labelEn,
    required this.price,
    required this.sortOrder,
    required this.isDeleted,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['menu_item_id'] = Variable<String>(menuItemId);
    map['label'] = Variable<String>(label);
    map['label_en'] = Variable<String>(labelEn);
    map['price'] = Variable<double>(price);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  MenuItemVariantsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemVariantsCompanion(
      id: Value(id),
      menuItemId: Value(menuItemId),
      label: Value(label),
      labelEn: Value(labelEn),
      price: Value(price),
      sortOrder: Value(sortOrder),
      isDeleted: Value(isDeleted),
      dirty: Value(dirty),
    );
  }

  factory MenuItemVariant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItemVariant(
      id: serializer.fromJson<String>(json['id']),
      menuItemId: serializer.fromJson<String>(json['menuItemId']),
      label: serializer.fromJson<String>(json['label']),
      labelEn: serializer.fromJson<String>(json['labelEn']),
      price: serializer.fromJson<double>(json['price']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'menuItemId': serializer.toJson<String>(menuItemId),
      'label': serializer.toJson<String>(label),
      'labelEn': serializer.toJson<String>(labelEn),
      'price': serializer.toJson<double>(price),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  MenuItemVariant copyWith({
    String? id,
    String? menuItemId,
    String? label,
    String? labelEn,
    double? price,
    int? sortOrder,
    bool? isDeleted,
    bool? dirty,
  }) => MenuItemVariant(
    id: id ?? this.id,
    menuItemId: menuItemId ?? this.menuItemId,
    label: label ?? this.label,
    labelEn: labelEn ?? this.labelEn,
    price: price ?? this.price,
    sortOrder: sortOrder ?? this.sortOrder,
    isDeleted: isDeleted ?? this.isDeleted,
    dirty: dirty ?? this.dirty,
  );
  MenuItemVariant copyWithCompanion(MenuItemVariantsCompanion data) {
    return MenuItemVariant(
      id: data.id.present ? data.id.value : this.id,
      menuItemId: data.menuItemId.present
          ? data.menuItemId.value
          : this.menuItemId,
      label: data.label.present ? data.label.value : this.label,
      labelEn: data.labelEn.present ? data.labelEn.value : this.labelEn,
      price: data.price.present ? data.price.value : this.price,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemVariant(')
          ..write('id: $id, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('label: $label, ')
          ..write('labelEn: $labelEn, ')
          ..write('price: $price, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    menuItemId,
    label,
    labelEn,
    price,
    sortOrder,
    isDeleted,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItemVariant &&
          other.id == this.id &&
          other.menuItemId == this.menuItemId &&
          other.label == this.label &&
          other.labelEn == this.labelEn &&
          other.price == this.price &&
          other.sortOrder == this.sortOrder &&
          other.isDeleted == this.isDeleted &&
          other.dirty == this.dirty);
}

class MenuItemVariantsCompanion extends UpdateCompanion<MenuItemVariant> {
  final Value<String> id;
  final Value<String> menuItemId;
  final Value<String> label;
  final Value<String> labelEn;
  final Value<double> price;
  final Value<int> sortOrder;
  final Value<bool> isDeleted;
  final Value<bool> dirty;
  final Value<int> rowid;
  const MenuItemVariantsCompanion({
    this.id = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.label = const Value.absent(),
    this.labelEn = const Value.absent(),
    this.price = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenuItemVariantsCompanion.insert({
    required String id,
    required String menuItemId,
    required String label,
    this.labelEn = const Value.absent(),
    required double price,
    this.sortOrder = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       menuItemId = Value(menuItemId),
       label = Value(label),
       price = Value(price);
  static Insertable<MenuItemVariant> custom({
    Expression<String>? id,
    Expression<String>? menuItemId,
    Expression<String>? label,
    Expression<String>? labelEn,
    Expression<double>? price,
    Expression<int>? sortOrder,
    Expression<bool>? isDeleted,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (label != null) 'label': label,
      if (labelEn != null) 'label_en': labelEn,
      if (price != null) 'price': price,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenuItemVariantsCompanion copyWith({
    Value<String>? id,
    Value<String>? menuItemId,
    Value<String>? label,
    Value<String>? labelEn,
    Value<double>? price,
    Value<int>? sortOrder,
    Value<bool>? isDeleted,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return MenuItemVariantsCompanion(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      label: label ?? this.label,
      labelEn: labelEn ?? this.labelEn,
      price: price ?? this.price,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<String>(menuItemId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (labelEn.present) {
      map['label_en'] = Variable<String>(labelEn.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemVariantsCompanion(')
          ..write('id: $id, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('label: $label, ')
          ..write('labelEn: $labelEn, ')
          ..write('price: $price, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceAuthTable extends DeviceAuth
    with TableInfo<$DeviceAuthTable, DeviceAuthData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceAuthTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<String> tenantId = GeneratedColumn<String>(
    'tenant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionTokenMeta = const VerificationMeta(
    'sessionToken',
  );
  @override
  late final GeneratedColumn<String> sessionToken = GeneratedColumn<String>(
    'session_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tokenExpiresAtMeta = const VerificationMeta(
    'tokenExpiresAt',
  );
  @override
  late final GeneratedColumn<String> tokenExpiresAt = GeneratedColumn<String>(
    'token_expires_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    tenantId,
    email,
    sessionToken,
    tokenExpiresAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_auth';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceAuthData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('session_token')) {
      context.handle(
        _sessionTokenMeta,
        sessionToken.isAcceptableOrUnknown(
          data['session_token']!,
          _sessionTokenMeta,
        ),
      );
    }
    if (data.containsKey('token_expires_at')) {
      context.handle(
        _tokenExpiresAtMeta,
        tokenExpiresAt.isAcceptableOrUnknown(
          data['token_expires_at']!,
          _tokenExpiresAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceAuthData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceAuthData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenant_id'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      sessionToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_token'],
      ),
      tokenExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_expires_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $DeviceAuthTable createAlias(String alias) {
    return $DeviceAuthTable(attachedDatabase, alias);
  }
}

class DeviceAuthData extends DataClass implements Insertable<DeviceAuthData> {
  final int id;
  final String? userId;
  final String? tenantId;
  final String? email;
  final String? sessionToken;
  final String? tokenExpiresAt;
  final String? createdAt;
  const DeviceAuthData({
    required this.id,
    this.userId,
    this.tenantId,
    this.email,
    this.sessionToken,
    this.tokenExpiresAt,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || tenantId != null) {
      map['tenant_id'] = Variable<String>(tenantId);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || sessionToken != null) {
      map['session_token'] = Variable<String>(sessionToken);
    }
    if (!nullToAbsent || tokenExpiresAt != null) {
      map['token_expires_at'] = Variable<String>(tokenExpiresAt);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    return map;
  }

  DeviceAuthCompanion toCompanion(bool nullToAbsent) {
    return DeviceAuthCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      tenantId: tenantId == null && nullToAbsent
          ? const Value.absent()
          : Value(tenantId),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      sessionToken: sessionToken == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionToken),
      tokenExpiresAt: tokenExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenExpiresAt),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory DeviceAuthData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceAuthData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      tenantId: serializer.fromJson<String?>(json['tenantId']),
      email: serializer.fromJson<String?>(json['email']),
      sessionToken: serializer.fromJson<String?>(json['sessionToken']),
      tokenExpiresAt: serializer.fromJson<String?>(json['tokenExpiresAt']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String?>(userId),
      'tenantId': serializer.toJson<String?>(tenantId),
      'email': serializer.toJson<String?>(email),
      'sessionToken': serializer.toJson<String?>(sessionToken),
      'tokenExpiresAt': serializer.toJson<String?>(tokenExpiresAt),
      'createdAt': serializer.toJson<String?>(createdAt),
    };
  }

  DeviceAuthData copyWith({
    int? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> tenantId = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> sessionToken = const Value.absent(),
    Value<String?> tokenExpiresAt = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
  }) => DeviceAuthData(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    tenantId: tenantId.present ? tenantId.value : this.tenantId,
    email: email.present ? email.value : this.email,
    sessionToken: sessionToken.present ? sessionToken.value : this.sessionToken,
    tokenExpiresAt: tokenExpiresAt.present
        ? tokenExpiresAt.value
        : this.tokenExpiresAt,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  DeviceAuthData copyWithCompanion(DeviceAuthCompanion data) {
    return DeviceAuthData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      email: data.email.present ? data.email.value : this.email,
      sessionToken: data.sessionToken.present
          ? data.sessionToken.value
          : this.sessionToken,
      tokenExpiresAt: data.tokenExpiresAt.present
          ? data.tokenExpiresAt.value
          : this.tokenExpiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceAuthData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tenantId: $tenantId, ')
          ..write('email: $email, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    tenantId,
    email,
    sessionToken,
    tokenExpiresAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceAuthData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.tenantId == this.tenantId &&
          other.email == this.email &&
          other.sessionToken == this.sessionToken &&
          other.tokenExpiresAt == this.tokenExpiresAt &&
          other.createdAt == this.createdAt);
}

class DeviceAuthCompanion extends UpdateCompanion<DeviceAuthData> {
  final Value<int> id;
  final Value<String?> userId;
  final Value<String?> tenantId;
  final Value<String?> email;
  final Value<String?> sessionToken;
  final Value<String?> tokenExpiresAt;
  final Value<String?> createdAt;
  const DeviceAuthCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.email = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DeviceAuthCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.email = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.tokenExpiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<DeviceAuthData> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? tenantId,
    Expression<String>? email,
    Expression<String>? sessionToken,
    Expression<String>? tokenExpiresAt,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (email != null) 'email': email,
      if (sessionToken != null) 'session_token': sessionToken,
      if (tokenExpiresAt != null) 'token_expires_at': tokenExpiresAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DeviceAuthCompanion copyWith({
    Value<int>? id,
    Value<String?>? userId,
    Value<String?>? tenantId,
    Value<String?>? email,
    Value<String?>? sessionToken,
    Value<String?>? tokenExpiresAt,
    Value<String?>? createdAt,
  }) {
    return DeviceAuthCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tenantId: tenantId ?? this.tenantId,
      email: email ?? this.email,
      sessionToken: sessionToken ?? this.sessionToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<String>(tenantId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (sessionToken.present) {
      map['session_token'] = Variable<String>(sessionToken.value);
    }
    if (tokenExpiresAt.present) {
      map['token_expires_at'] = Variable<String>(tokenExpiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceAuthCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tenantId: $tenantId, ')
          ..write('email: $email, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('tokenExpiresAt: $tokenExpiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPullAtMeta = const VerificationMeta(
    'lastPullAt',
  );
  @override
  late final GeneratedColumn<String> lastPullAt = GeneratedColumn<String>(
    'last_pull_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPushAtMeta = const VerificationMeta(
    'lastPushAt',
  );
  @override
  late final GeneratedColumn<String> lastPushAt = GeneratedColumn<String>(
    'last_push_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingCountMeta = const VerificationMeta(
    'pendingCount',
  );
  @override
  late final GeneratedColumn<int> pendingCount = GeneratedColumn<int>(
    'pending_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastPullAt,
    lastPushAt,
    pendingCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_pull_at')) {
      context.handle(
        _lastPullAtMeta,
        lastPullAt.isAcceptableOrUnknown(
          data['last_pull_at']!,
          _lastPullAtMeta,
        ),
      );
    }
    if (data.containsKey('last_push_at')) {
      context.handle(
        _lastPushAtMeta,
        lastPushAt.isAcceptableOrUnknown(
          data['last_push_at']!,
          _lastPushAtMeta,
        ),
      );
    }
    if (data.containsKey('pending_count')) {
      context.handle(
        _pendingCountMeta,
        pendingCount.isAcceptableOrUnknown(
          data['pending_count']!,
          _pendingCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastPullAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_pull_at'],
      ),
      lastPushAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_push_at'],
      ),
      pendingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_count'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final int id;
  final String? lastPullAt;
  final String? lastPushAt;
  final int pendingCount;
  const SyncStateData({
    required this.id,
    this.lastPullAt,
    this.lastPushAt,
    required this.pendingCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastPullAt != null) {
      map['last_pull_at'] = Variable<String>(lastPullAt);
    }
    if (!nullToAbsent || lastPushAt != null) {
      map['last_push_at'] = Variable<String>(lastPushAt);
    }
    map['pending_count'] = Variable<int>(pendingCount);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      lastPullAt: lastPullAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPullAt),
      lastPushAt: lastPushAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPushAt),
      pendingCount: Value(pendingCount),
    );
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      id: serializer.fromJson<int>(json['id']),
      lastPullAt: serializer.fromJson<String?>(json['lastPullAt']),
      lastPushAt: serializer.fromJson<String?>(json['lastPushAt']),
      pendingCount: serializer.fromJson<int>(json['pendingCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastPullAt': serializer.toJson<String?>(lastPullAt),
      'lastPushAt': serializer.toJson<String?>(lastPushAt),
      'pendingCount': serializer.toJson<int>(pendingCount),
    };
  }

  SyncStateData copyWith({
    int? id,
    Value<String?> lastPullAt = const Value.absent(),
    Value<String?> lastPushAt = const Value.absent(),
    int? pendingCount,
  }) => SyncStateData(
    id: id ?? this.id,
    lastPullAt: lastPullAt.present ? lastPullAt.value : this.lastPullAt,
    lastPushAt: lastPushAt.present ? lastPushAt.value : this.lastPushAt,
    pendingCount: pendingCount ?? this.pendingCount,
  );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      id: data.id.present ? data.id.value : this.id,
      lastPullAt: data.lastPullAt.present
          ? data.lastPullAt.value
          : this.lastPullAt,
      lastPushAt: data.lastPushAt.present
          ? data.lastPushAt.value
          : this.lastPushAt,
      pendingCount: data.pendingCount.present
          ? data.pendingCount.value
          : this.pendingCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('id: $id, ')
          ..write('lastPullAt: $lastPullAt, ')
          ..write('lastPushAt: $lastPushAt, ')
          ..write('pendingCount: $pendingCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastPullAt, lastPushAt, pendingCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.id == this.id &&
          other.lastPullAt == this.lastPullAt &&
          other.lastPushAt == this.lastPushAt &&
          other.pendingCount == this.pendingCount);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<int> id;
  final Value<String?> lastPullAt;
  final Value<String?> lastPushAt;
  final Value<int> pendingCount;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.lastPullAt = const Value.absent(),
    this.lastPushAt = const Value.absent(),
    this.pendingCount = const Value.absent(),
  });
  SyncStateCompanion.insert({
    this.id = const Value.absent(),
    this.lastPullAt = const Value.absent(),
    this.lastPushAt = const Value.absent(),
    this.pendingCount = const Value.absent(),
  });
  static Insertable<SyncStateData> custom({
    Expression<int>? id,
    Expression<String>? lastPullAt,
    Expression<String>? lastPushAt,
    Expression<int>? pendingCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastPullAt != null) 'last_pull_at': lastPullAt,
      if (lastPushAt != null) 'last_push_at': lastPushAt,
      if (pendingCount != null) 'pending_count': pendingCount,
    });
  }

  SyncStateCompanion copyWith({
    Value<int>? id,
    Value<String?>? lastPullAt,
    Value<String?>? lastPushAt,
    Value<int>? pendingCount,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      lastPullAt: lastPullAt ?? this.lastPullAt,
      lastPushAt: lastPushAt ?? this.lastPushAt,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastPullAt.present) {
      map['last_pull_at'] = Variable<String>(lastPullAt.value);
    }
    if (lastPushAt.present) {
      map['last_push_at'] = Variable<String>(lastPushAt.value);
    }
    if (pendingCount.present) {
      map['pending_count'] = Variable<int>(pendingCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('lastPullAt: $lastPullAt, ')
          ..write('lastPushAt: $lastPushAt, ')
          ..write('pendingCount: $pendingCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $TenantsTable tenants = $TenantsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $CategoryTranslationsTable categoryTranslations =
      $CategoryTranslationsTable(this);
  late final $MenuItemsTable menuItems = $MenuItemsTable(this);
  late final $MenuItemTranslationsTable menuItemTranslations =
      $MenuItemTranslationsTable(this);
  late final $MenuItemVariantsTable menuItemVariants = $MenuItemVariantsTable(
    this,
  );
  late final $DeviceAuthTable deviceAuth = $DeviceAuthTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tenants,
    categories,
    categoryTranslations,
    menuItems,
    menuItemTranslations,
    menuItemVariants,
    deviceAuth,
    syncState,
  ];
}

typedef $$TenantsTableCreateCompanionBuilder = TenantsCompanion Function({
  required String id,
  required String name,
  required String slug,
  Value<String> plan,
  Value<bool> isActive,
  Value<String> primaryColor,
  Value<String> secondaryColor,
  Value<String> accentColor,
  Value<String> backgroundColor,
  Value<String> surfaceColor,
  Value<String> textColor,
  Value<String> textMuted,
  Value<String> headingFont,
  Value<String> bodyFont,
  Value<String> borderRadiusSm,
  Value<String> borderRadiusMd,
  Value<String> borderRadiusLg,
  Value<String> cardStyle,
  Value<String> menuLayout,
  Value<String> spacing,
  Value<String?> logoUrl,
  Value<String?> coverUrl,
  Value<String?> description,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> instagram,
  Value<String?> website,
  Value<String> defaultLocale,
  Value<String> availableLocalesCsv,
  Value<String?> lastSyncAt,
  Value<int> rowid,
});
typedef $$TenantsTableUpdateCompanionBuilder = TenantsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> slug,
  Value<String> plan,
  Value<bool> isActive,
  Value<String> primaryColor,
  Value<String> secondaryColor,
  Value<String> accentColor,
  Value<String> backgroundColor,
  Value<String> surfaceColor,
  Value<String> textColor,
  Value<String> textMuted,
  Value<String> headingFont,
  Value<String> bodyFont,
  Value<String> borderRadiusSm,
  Value<String> borderRadiusMd,
  Value<String> borderRadiusLg,
  Value<String> cardStyle,
  Value<String> menuLayout,
  Value<String> spacing,
  Value<String?> logoUrl,
  Value<String?> coverUrl,
  Value<String?> description,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> instagram,
  Value<String?> website,
  Value<String> defaultLocale,
  Value<String> availableLocalesCsv,
  Value<String?> lastSyncAt,
  Value<int> rowid,
});

class $$TenantsTableFilterComposer extends Composer<_$AppDb, $TenantsTable> {
  $$TenantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryColor => $composableBuilder(
    column: $table.secondaryColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surfaceColor => $composableBuilder(
    column: $table.surfaceColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textColor => $composableBuilder(
    column: $table.textColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textMuted => $composableBuilder(
    column: $table.textMuted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headingFont => $composableBuilder(
    column: $table.headingFont,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyFont => $composableBuilder(
    column: $table.bodyFont,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get borderRadiusSm => $composableBuilder(
    column: $table.borderRadiusSm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get borderRadiusMd => $composableBuilder(
    column: $table.borderRadiusMd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get borderRadiusLg => $composableBuilder(
    column: $table.borderRadiusLg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardStyle => $composableBuilder(
    column: $table.cardStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get menuLayout => $composableBuilder(
    column: $table.menuLayout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spacing => $composableBuilder(
    column: $table.spacing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultLocale => $composableBuilder(
    column: $table.defaultLocale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableLocalesCsv => $composableBuilder(
    column: $table.availableLocalesCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TenantsTableOrderingComposer extends Composer<_$AppDb, $TenantsTable> {
  $$TenantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryColor => $composableBuilder(
    column: $table.secondaryColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surfaceColor => $composableBuilder(
    column: $table.surfaceColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textColor => $composableBuilder(
    column: $table.textColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textMuted => $composableBuilder(
    column: $table.textMuted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headingFont => $composableBuilder(
    column: $table.headingFont,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyFont => $composableBuilder(
    column: $table.bodyFont,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get borderRadiusSm => $composableBuilder(
    column: $table.borderRadiusSm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get borderRadiusMd => $composableBuilder(
    column: $table.borderRadiusMd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get borderRadiusLg => $composableBuilder(
    column: $table.borderRadiusLg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardStyle => $composableBuilder(
    column: $table.cardStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get menuLayout => $composableBuilder(
    column: $table.menuLayout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spacing => $composableBuilder(
    column: $table.spacing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultLocale => $composableBuilder(
    column: $table.defaultLocale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableLocalesCsv => $composableBuilder(
    column: $table.availableLocalesCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TenantsTableAnnotationComposer
    extends Composer<_$AppDb, $TenantsTable> {
  $$TenantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryColor => $composableBuilder(
    column: $table.secondaryColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get surfaceColor => $composableBuilder(
    column: $table.surfaceColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textColor =>
      $composableBuilder(column: $table.textColor, builder: (column) => column);

  GeneratedColumn<String> get textMuted =>
      $composableBuilder(column: $table.textMuted, builder: (column) => column);

  GeneratedColumn<String> get headingFont => $composableBuilder(
    column: $table.headingFont,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyFont =>
      $composableBuilder(column: $table.bodyFont, builder: (column) => column);

  GeneratedColumn<String> get borderRadiusSm => $composableBuilder(
    column: $table.borderRadiusSm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get borderRadiusMd => $composableBuilder(
    column: $table.borderRadiusMd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get borderRadiusLg => $composableBuilder(
    column: $table.borderRadiusLg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardStyle =>
      $composableBuilder(column: $table.cardStyle, builder: (column) => column);

  GeneratedColumn<String> get menuLayout => $composableBuilder(
    column: $table.menuLayout,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spacing =>
      $composableBuilder(column: $table.spacing, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get instagram =>
      $composableBuilder(column: $table.instagram, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get defaultLocale => $composableBuilder(
    column: $table.defaultLocale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availableLocalesCsv => $composableBuilder(
    column: $table.availableLocalesCsv,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$TenantsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TenantsTable,
          Tenant,
          $$TenantsTableFilterComposer,
          $$TenantsTableOrderingComposer,
          $$TenantsTableAnnotationComposer,
          $$TenantsTableCreateCompanionBuilder,
          $$TenantsTableUpdateCompanionBuilder,
          (Tenant, BaseReferences<_$AppDb, $TenantsTable, Tenant>),
          Tenant,
          PrefetchHooks Function()
        > {
  $$TenantsTableTableManager(_$AppDb db, $TenantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> plan = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> primaryColor = const Value.absent(),
                Value<String> secondaryColor = const Value.absent(),
                Value<String> accentColor = const Value.absent(),
                Value<String> backgroundColor = const Value.absent(),
                Value<String> surfaceColor = const Value.absent(),
                Value<String> textColor = const Value.absent(),
                Value<String> textMuted = const Value.absent(),
                Value<String> headingFont = const Value.absent(),
                Value<String> bodyFont = const Value.absent(),
                Value<String> borderRadiusSm = const Value.absent(),
                Value<String> borderRadiusMd = const Value.absent(),
                Value<String> borderRadiusLg = const Value.absent(),
                Value<String> cardStyle = const Value.absent(),
                Value<String> menuLayout = const Value.absent(),
                Value<String> spacing = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> instagram = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String> defaultLocale = const Value.absent(),
                Value<String> availableLocalesCsv = const Value.absent(),
                Value<String?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TenantsCompanion(
                id: id,
                name: name,
                slug: slug,
                plan: plan,
                isActive: isActive,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                accentColor: accentColor,
                backgroundColor: backgroundColor,
                surfaceColor: surfaceColor,
                textColor: textColor,
                textMuted: textMuted,
                headingFont: headingFont,
                bodyFont: bodyFont,
                borderRadiusSm: borderRadiusSm,
                borderRadiusMd: borderRadiusMd,
                borderRadiusLg: borderRadiusLg,
                cardStyle: cardStyle,
                menuLayout: menuLayout,
                spacing: spacing,
                logoUrl: logoUrl,
                coverUrl: coverUrl,
                description: description,
                address: address,
                phone: phone,
                instagram: instagram,
                website: website,
                defaultLocale: defaultLocale,
                availableLocalesCsv: availableLocalesCsv,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String slug,
                Value<String> plan = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> primaryColor = const Value.absent(),
                Value<String> secondaryColor = const Value.absent(),
                Value<String> accentColor = const Value.absent(),
                Value<String> backgroundColor = const Value.absent(),
                Value<String> surfaceColor = const Value.absent(),
                Value<String> textColor = const Value.absent(),
                Value<String> textMuted = const Value.absent(),
                Value<String> headingFont = const Value.absent(),
                Value<String> bodyFont = const Value.absent(),
                Value<String> borderRadiusSm = const Value.absent(),
                Value<String> borderRadiusMd = const Value.absent(),
                Value<String> borderRadiusLg = const Value.absent(),
                Value<String> cardStyle = const Value.absent(),
                Value<String> menuLayout = const Value.absent(),
                Value<String> spacing = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> instagram = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String> defaultLocale = const Value.absent(),
                Value<String> availableLocalesCsv = const Value.absent(),
                Value<String?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TenantsCompanion.insert(
                id: id,
                name: name,
                slug: slug,
                plan: plan,
                isActive: isActive,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                accentColor: accentColor,
                backgroundColor: backgroundColor,
                surfaceColor: surfaceColor,
                textColor: textColor,
                textMuted: textMuted,
                headingFont: headingFont,
                bodyFont: bodyFont,
                borderRadiusSm: borderRadiusSm,
                borderRadiusMd: borderRadiusMd,
                borderRadiusLg: borderRadiusLg,
                cardStyle: cardStyle,
                menuLayout: menuLayout,
                spacing: spacing,
                logoUrl: logoUrl,
                coverUrl: coverUrl,
                description: description,
                address: address,
                phone: phone,
                instagram: instagram,
                website: website,
                defaultLocale: defaultLocale,
                availableLocalesCsv: availableLocalesCsv,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TenantsTable, Tenant>(table),
                  BaseReferences<_$AppDb, $TenantsTable, Tenant>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TenantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TenantsTable,
      Tenant,
      $$TenantsTableFilterComposer,
      $$TenantsTableOrderingComposer,
      $$TenantsTableAnnotationComposer,
      $$TenantsTableCreateCompanionBuilder,
      $$TenantsTableUpdateCompanionBuilder,
      (Tenant, BaseReferences<_$AppDb, $TenantsTable, Tenant>),
      Tenant,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String tenantId,
  required String name,
  required String slug,
  Value<String?> description,
  Value<int> displayOrder,
  Value<bool> isActive,
  required String updatedAt,
  Value<bool> isDeleted,
  Value<bool> dirty,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> name,
  Value<String> slug,
  Value<String?> description,
  Value<int> displayOrder,
  Value<bool> isActive,
  Value<String> updatedAt,
  Value<bool> isDeleted,
  Value<bool> dirty,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDb, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDb, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDb, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDb, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDb db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                tenantId: tenantId,
                name: name,
                slug: slug,
                description: description,
                displayOrder: displayOrder,
                isActive: isActive,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String name,
                required String slug,
                Value<String?> description = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required String updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                tenantId: tenantId,
                name: name,
                slug: slug,
                description: description,
                displayOrder: displayOrder,
                isActive: isActive,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  BaseReferences<_$AppDb, $CategoriesTable, Category>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDb, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$CategoryTranslationsTableCreateCompanionBuilder =
    CategoryTranslationsCompanion Function({
      required String categoryId,
      required String locale,
      required String name,
      Value<String?> description,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$CategoryTranslationsTableUpdateCompanionBuilder =
    CategoryTranslationsCompanion Function({
      Value<String> categoryId,
      Value<String> locale,
      Value<String> name,
      Value<String?> description,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$CategoryTranslationsTableFilterComposer
    extends Composer<_$AppDb, $CategoryTranslationsTable> {
  $$CategoryTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoryTranslationsTableOrderingComposer
    extends Composer<_$AppDb, $CategoryTranslationsTable> {
  $$CategoryTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryTranslationsTableAnnotationComposer
    extends Composer<_$AppDb, $CategoryTranslationsTable> {
  $$CategoryTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$CategoryTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $CategoryTranslationsTable,
          CategoryTranslation,
          $$CategoryTranslationsTableFilterComposer,
          $$CategoryTranslationsTableOrderingComposer,
          $$CategoryTranslationsTableAnnotationComposer,
          $$CategoryTranslationsTableCreateCompanionBuilder,
          $$CategoryTranslationsTableUpdateCompanionBuilder,
          (
            CategoryTranslation,
            BaseReferences<
              _$AppDb,
              $CategoryTranslationsTable,
              CategoryTranslation
            >,
          ),
          CategoryTranslation,
          PrefetchHooks Function()
        > {
  $$CategoryTranslationsTableTableManager(
    _$AppDb db,
    $CategoryTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CategoryTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> categoryId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryTranslationsCompanion(
                categoryId: categoryId,
                locale: locale,
                name: name,
                description: description,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String categoryId,
                required String locale,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryTranslationsCompanion.insert(
                categoryId: categoryId,
                locale: locale,
                name: name,
                description: description,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoryTranslationsTable, CategoryTranslation>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDb,
                    $CategoryTranslationsTable,
                    CategoryTranslation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoryTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $CategoryTranslationsTable,
      CategoryTranslation,
      $$CategoryTranslationsTableFilterComposer,
      $$CategoryTranslationsTableOrderingComposer,
      $$CategoryTranslationsTableAnnotationComposer,
      $$CategoryTranslationsTableCreateCompanionBuilder,
      $$CategoryTranslationsTableUpdateCompanionBuilder,
      (
        CategoryTranslation,
        BaseReferences<
          _$AppDb,
          $CategoryTranslationsTable,
          CategoryTranslation
        >,
      ),
      CategoryTranslation,
      PrefetchHooks Function()
    >;
typedef $$MenuItemsTableCreateCompanionBuilder = MenuItemsCompanion Function({
  required String id,
  required String tenantId,
  required String categoryId,
  required String name,
  Value<String?> description,
  Value<double?> basePrice,
  Value<String?> imageUrl,
  Value<bool> isAvailable,
  Value<int> displayOrder,
  Value<String> dietaryTagsCsv,
  required String updatedAt,
  Value<bool> isDeleted,
  Value<bool> dirty,
  Value<int> rowid,
});
typedef $$MenuItemsTableUpdateCompanionBuilder = MenuItemsCompanion Function({
  Value<String> id,
  Value<String> tenantId,
  Value<String> categoryId,
  Value<String> name,
  Value<String?> description,
  Value<double?> basePrice,
  Value<String?> imageUrl,
  Value<bool> isAvailable,
  Value<int> displayOrder,
  Value<String> dietaryTagsCsv,
  Value<String> updatedAt,
  Value<bool> isDeleted,
  Value<bool> dirty,
  Value<int> rowid,
});

class $$MenuItemsTableFilterComposer
    extends Composer<_$AppDb, $MenuItemsTable> {
  $$MenuItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietaryTagsCsv => $composableBuilder(
    column: $table.dietaryTagsCsv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MenuItemsTableOrderingComposer
    extends Composer<_$AppDb, $MenuItemsTable> {
  $$MenuItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietaryTagsCsv => $composableBuilder(
    column: $table.dietaryTagsCsv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MenuItemsTableAnnotationComposer
    extends Composer<_$AppDb, $MenuItemsTable> {
  $$MenuItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get basePrice =>
      $composableBuilder(column: $table.basePrice, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietaryTagsCsv => $composableBuilder(
    column: $table.dietaryTagsCsv,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$MenuItemsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MenuItemsTable,
          MenuItem,
          $$MenuItemsTableFilterComposer,
          $$MenuItemsTableOrderingComposer,
          $$MenuItemsTableAnnotationComposer,
          $$MenuItemsTableCreateCompanionBuilder,
          $$MenuItemsTableUpdateCompanionBuilder,
          (MenuItem, BaseReferences<_$AppDb, $MenuItemsTable, MenuItem>),
          MenuItem,
          PrefetchHooks Function()
        > {
  $$MenuItemsTableTableManager(_$AppDb db, $MenuItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tenantId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> basePrice = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String> dietaryTagsCsv = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemsCompanion(
                id: id,
                tenantId: tenantId,
                categoryId: categoryId,
                name: name,
                description: description,
                basePrice: basePrice,
                imageUrl: imageUrl,
                isAvailable: isAvailable,
                displayOrder: displayOrder,
                dietaryTagsCsv: dietaryTagsCsv,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tenantId,
                required String categoryId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<double?> basePrice = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isAvailable = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String> dietaryTagsCsv = const Value.absent(),
                required String updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemsCompanion.insert(
                id: id,
                tenantId: tenantId,
                categoryId: categoryId,
                name: name,
                description: description,
                basePrice: basePrice,
                imageUrl: imageUrl,
                isAvailable: isAvailable,
                displayOrder: displayOrder,
                dietaryTagsCsv: dietaryTagsCsv,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MenuItemsTable, MenuItem>(table),
                  BaseReferences<_$AppDb, $MenuItemsTable, MenuItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenuItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MenuItemsTable,
      MenuItem,
      $$MenuItemsTableFilterComposer,
      $$MenuItemsTableOrderingComposer,
      $$MenuItemsTableAnnotationComposer,
      $$MenuItemsTableCreateCompanionBuilder,
      $$MenuItemsTableUpdateCompanionBuilder,
      (MenuItem, BaseReferences<_$AppDb, $MenuItemsTable, MenuItem>),
      MenuItem,
      PrefetchHooks Function()
    >;
typedef $$MenuItemTranslationsTableCreateCompanionBuilder =
    MenuItemTranslationsCompanion Function({
      required String menuItemId,
      required String locale,
      required String name,
      Value<String?> description,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$MenuItemTranslationsTableUpdateCompanionBuilder =
    MenuItemTranslationsCompanion Function({
      Value<String> menuItemId,
      Value<String> locale,
      Value<String> name,
      Value<String?> description,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$MenuItemTranslationsTableFilterComposer
    extends Composer<_$AppDb, $MenuItemTranslationsTable> {
  $$MenuItemTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MenuItemTranslationsTableOrderingComposer
    extends Composer<_$AppDb, $MenuItemTranslationsTable> {
  $$MenuItemTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MenuItemTranslationsTableAnnotationComposer
    extends Composer<_$AppDb, $MenuItemTranslationsTable> {
  $$MenuItemTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$MenuItemTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MenuItemTranslationsTable,
          MenuItemTranslation,
          $$MenuItemTranslationsTableFilterComposer,
          $$MenuItemTranslationsTableOrderingComposer,
          $$MenuItemTranslationsTableAnnotationComposer,
          $$MenuItemTranslationsTableCreateCompanionBuilder,
          $$MenuItemTranslationsTableUpdateCompanionBuilder,
          (
            MenuItemTranslation,
            BaseReferences<
              _$AppDb,
              $MenuItemTranslationsTable,
              MenuItemTranslation
            >,
          ),
          MenuItemTranslation,
          PrefetchHooks Function()
        > {
  $$MenuItemTranslationsTableTableManager(
    _$AppDb db,
    $MenuItemTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MenuItemTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> menuItemId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemTranslationsCompanion(
                menuItemId: menuItemId,
                locale: locale,
                name: name,
                description: description,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String menuItemId,
                required String locale,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemTranslationsCompanion.insert(
                menuItemId: menuItemId,
                locale: locale,
                name: name,
                description: description,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MenuItemTranslationsTable, MenuItemTranslation>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDb,
                    $MenuItemTranslationsTable,
                    MenuItemTranslation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenuItemTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MenuItemTranslationsTable,
      MenuItemTranslation,
      $$MenuItemTranslationsTableFilterComposer,
      $$MenuItemTranslationsTableOrderingComposer,
      $$MenuItemTranslationsTableAnnotationComposer,
      $$MenuItemTranslationsTableCreateCompanionBuilder,
      $$MenuItemTranslationsTableUpdateCompanionBuilder,
      (
        MenuItemTranslation,
        BaseReferences<
          _$AppDb,
          $MenuItemTranslationsTable,
          MenuItemTranslation
        >,
      ),
      MenuItemTranslation,
      PrefetchHooks Function()
    >;
typedef $$MenuItemVariantsTableCreateCompanionBuilder =
    MenuItemVariantsCompanion Function({
      required String id,
      required String menuItemId,
      required String label,
      Value<String> labelEn,
      required double price,
      Value<int> sortOrder,
      Value<bool> isDeleted,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$MenuItemVariantsTableUpdateCompanionBuilder =
    MenuItemVariantsCompanion Function({
      Value<String> id,
      Value<String> menuItemId,
      Value<String> label,
      Value<String> labelEn,
      Value<double> price,
      Value<int> sortOrder,
      Value<bool> isDeleted,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$MenuItemVariantsTableFilterComposer
    extends Composer<_$AppDb, $MenuItemVariantsTable> {
  $$MenuItemVariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labelEn => $composableBuilder(
    column: $table.labelEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MenuItemVariantsTableOrderingComposer
    extends Composer<_$AppDb, $MenuItemVariantsTable> {
  $$MenuItemVariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelEn => $composableBuilder(
    column: $table.labelEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MenuItemVariantsTableAnnotationComposer
    extends Composer<_$AppDb, $MenuItemVariantsTable> {
  $$MenuItemVariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get menuItemId => $composableBuilder(
    column: $table.menuItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get labelEn =>
      $composableBuilder(column: $table.labelEn, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$MenuItemVariantsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MenuItemVariantsTable,
          MenuItemVariant,
          $$MenuItemVariantsTableFilterComposer,
          $$MenuItemVariantsTableOrderingComposer,
          $$MenuItemVariantsTableAnnotationComposer,
          $$MenuItemVariantsTableCreateCompanionBuilder,
          $$MenuItemVariantsTableUpdateCompanionBuilder,
          (
            MenuItemVariant,
            BaseReferences<_$AppDb, $MenuItemVariantsTable, MenuItemVariant>,
          ),
          MenuItemVariant,
          PrefetchHooks Function()
        > {
  $$MenuItemVariantsTableTableManager(_$AppDb db, $MenuItemVariantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemVariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemVariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemVariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> menuItemId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> labelEn = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemVariantsCompanion(
                id: id,
                menuItemId: menuItemId,
                label: label,
                labelEn: labelEn,
                price: price,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String menuItemId,
                required String label,
                Value<String> labelEn = const Value.absent(),
                required double price,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MenuItemVariantsCompanion.insert(
                id: id,
                menuItemId: menuItemId,
                label: label,
                labelEn: labelEn,
                price: price,
                sortOrder: sortOrder,
                isDeleted: isDeleted,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MenuItemVariantsTable, MenuItemVariant>(table),
                  BaseReferences<
                    _$AppDb,
                    $MenuItemVariantsTable,
                    MenuItemVariant
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MenuItemVariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MenuItemVariantsTable,
      MenuItemVariant,
      $$MenuItemVariantsTableFilterComposer,
      $$MenuItemVariantsTableOrderingComposer,
      $$MenuItemVariantsTableAnnotationComposer,
      $$MenuItemVariantsTableCreateCompanionBuilder,
      $$MenuItemVariantsTableUpdateCompanionBuilder,
      (
        MenuItemVariant,
        BaseReferences<_$AppDb, $MenuItemVariantsTable, MenuItemVariant>,
      ),
      MenuItemVariant,
      PrefetchHooks Function()
    >;
typedef $$DeviceAuthTableCreateCompanionBuilder = DeviceAuthCompanion Function({
  Value<int> id,
  Value<String?> userId,
  Value<String?> tenantId,
  Value<String?> email,
  Value<String?> sessionToken,
  Value<String?> tokenExpiresAt,
  Value<String?> createdAt,
});
typedef $$DeviceAuthTableUpdateCompanionBuilder = DeviceAuthCompanion Function({
  Value<int> id,
  Value<String?> userId,
  Value<String?> tenantId,
  Value<String?> email,
  Value<String?> sessionToken,
  Value<String?> tokenExpiresAt,
  Value<String?> createdAt,
});

class $$DeviceAuthTableFilterComposer
    extends Composer<_$AppDb, $DeviceAuthTable> {
  $$DeviceAuthTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceAuthTableOrderingComposer
    extends Composer<_$AppDb, $DeviceAuthTable> {
  $$DeviceAuthTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenantId => $composableBuilder(
    column: $table.tenantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceAuthTableAnnotationComposer
    extends Composer<_$AppDb, $DeviceAuthTable> {
  $$DeviceAuthTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tokenExpiresAt => $composableBuilder(
    column: $table.tokenExpiresAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DeviceAuthTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $DeviceAuthTable,
          DeviceAuthData,
          $$DeviceAuthTableFilterComposer,
          $$DeviceAuthTableOrderingComposer,
          $$DeviceAuthTableAnnotationComposer,
          $$DeviceAuthTableCreateCompanionBuilder,
          $$DeviceAuthTableUpdateCompanionBuilder,
          (
            DeviceAuthData,
            BaseReferences<_$AppDb, $DeviceAuthTable, DeviceAuthData>,
          ),
          DeviceAuthData,
          PrefetchHooks Function()
        > {
  $$DeviceAuthTableTableManager(_$AppDb db, $DeviceAuthTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceAuthTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceAuthTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceAuthTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> tenantId = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> sessionToken = const Value.absent(),
                Value<String?> tokenExpiresAt = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
              }) => DeviceAuthCompanion(
                id: id,
                userId: userId,
                tenantId: tenantId,
                email: email,
                sessionToken: sessionToken,
                tokenExpiresAt: tokenExpiresAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> tenantId = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> sessionToken = const Value.absent(),
                Value<String?> tokenExpiresAt = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
              }) => DeviceAuthCompanion.insert(
                id: id,
                userId: userId,
                tenantId: tenantId,
                email: email,
                sessionToken: sessionToken,
                tokenExpiresAt: tokenExpiresAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceAuthTable, DeviceAuthData>(table),
                  BaseReferences<_$AppDb, $DeviceAuthTable, DeviceAuthData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceAuthTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $DeviceAuthTable,
      DeviceAuthData,
      $$DeviceAuthTableFilterComposer,
      $$DeviceAuthTableOrderingComposer,
      $$DeviceAuthTableAnnotationComposer,
      $$DeviceAuthTableCreateCompanionBuilder,
      $$DeviceAuthTableUpdateCompanionBuilder,
      (
        DeviceAuthData,
        BaseReferences<_$AppDb, $DeviceAuthTable, DeviceAuthData>,
      ),
      DeviceAuthData,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder = SyncStateCompanion Function({
  Value<int> id,
  Value<String?> lastPullAt,
  Value<String?> lastPushAt,
  Value<int> pendingCount,
});
typedef $$SyncStateTableUpdateCompanionBuilder = SyncStateCompanion Function({
  Value<int> id,
  Value<String?> lastPullAt,
  Value<String?> lastPushAt,
  Value<int> pendingCount,
});

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDb, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPullAt => $composableBuilder(
    column: $table.lastPullAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDb, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPullAt => $composableBuilder(
    column: $table.lastPullAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDb, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastPullAt => $composableBuilder(
    column: $table.lastPullAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastPushAt => $composableBuilder(
    column: $table.lastPushAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingCount => $composableBuilder(
    column: $table.pendingCount,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDb, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDb db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> lastPullAt = const Value.absent(),
                Value<String?> lastPushAt = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                lastPullAt: lastPullAt,
                lastPushAt: lastPushAt,
                pendingCount: pendingCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> lastPullAt = const Value.absent(),
                Value<String?> lastPushAt = const Value.absent(),
                Value<int> pendingCount = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                lastPullAt: lastPullAt,
                lastPushAt: lastPushAt,
                pendingCount: pendingCount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStateTable, SyncStateData>(table),
                  BaseReferences<_$AppDb, $SyncStateTable, SyncStateData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (SyncStateData, BaseReferences<_$AppDb, $SyncStateTable, SyncStateData>),
      SyncStateData,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db, _db.tenants);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$CategoryTranslationsTableTableManager get categoryTranslations =>
      $$CategoryTranslationsTableTableManager(_db, _db.categoryTranslations);
  $$MenuItemsTableTableManager get menuItems =>
      $$MenuItemsTableTableManager(_db, _db.menuItems);
  $$MenuItemTranslationsTableTableManager get menuItemTranslations =>
      $$MenuItemTranslationsTableTableManager(_db, _db.menuItemTranslations);
  $$MenuItemVariantsTableTableManager get menuItemVariants =>
      $$MenuItemVariantsTableTableManager(_db, _db.menuItemVariants);
  $$DeviceAuthTableTableManager get deviceAuth =>
      $$DeviceAuthTableTableManager(_db, _db.deviceAuth);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}
