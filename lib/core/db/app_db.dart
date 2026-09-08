import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

/// Local offline-first cache of the Postgres backend (docs/PLAN.md §4).
/// URLs only — image bytes live in the HTTP disk cache / pinned files.
/// `updatedAt` mirrors the server ISO-8601 stamp (lexicographic compare works).
/// `dirty` marks rows the tablet changed and must push (docs/PLAN.md §7/§18).

class Tenants extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get plan => text().withDefault(const Constant('FREE'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  // Controlled theme tokens (customCss is deprecated — never stored).
  TextColumn get primaryColor => text().withDefault(const Constant('#e74c3c'))();
  TextColumn get secondaryColor => text().withDefault(const Constant('#2c3e50'))();
  TextColumn get accentColor => text().withDefault(const Constant('#f39c12'))();
  TextColumn get backgroundColor =>
      text().withDefault(const Constant('#fdf5e6'))();
  TextColumn get surfaceColor => text().withDefault(const Constant('#ffffff'))();
  TextColumn get textColor => text().withDefault(const Constant('#1a1a2e'))();
  TextColumn get textMuted => text().withDefault(const Constant('#64748b'))();
  TextColumn get headingFont => text().withDefault(const Constant('Cairo'))();
  TextColumn get bodyFont => text().withDefault(const Constant('Inter'))();
  TextColumn get borderRadiusSm => text().withDefault(const Constant('4px'))();
  TextColumn get borderRadiusMd => text().withDefault(const Constant('8px'))();
  TextColumn get borderRadiusLg => text().withDefault(const Constant('16px'))();
  TextColumn get cardStyle => text().withDefault(const Constant('elevated'))();
  TextColumn get menuLayout => text().withDefault(const Constant('single'))();
  TextColumn get spacing => text().withDefault(const Constant('comfortable'))();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get instagram => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get defaultLocale => text().withDefault(const Constant('ar'))();
  TextColumn get availableLocalesCsv =>
      text().withDefault(const Constant('ar,en'))();
  TextColumn get lastSyncAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get description => text().nullable()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get updatedAt => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class CategoryTranslations extends Table {
  TextColumn get categoryId => text()();
  TextColumn get locale => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {categoryId, locale};
}

class MenuItems extends Table {
  TextColumn get id => text()();
  TextColumn get tenantId => text()();
  TextColumn get categoryId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get basePrice => real().nullable()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  TextColumn get dietaryTagsCsv => text().withDefault(const Constant(''))();
  TextColumn get updatedAt => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class MenuItemTranslations extends Table {
  TextColumn get menuItemId => text()();
  TextColumn get locale => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {menuItemId, locale};
}

class MenuItemVariants extends Table {
  TextColumn get id => text()();
  TextColumn get menuItemId => text()();
  TextColumn get label => text()();
  TextColumn get labelEn => text().withDefault(const Constant(''))();
  RealColumn get price => real()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row (id = 1) cached better-auth session for offline admin (PLAN §8).
class DeviceAuth extends Table {
  IntColumn get id => integer()();
  TextColumn get userId => text().nullable()();
  TextColumn get tenantId => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get sessionToken => text().nullable()();
  TextColumn get tokenExpiresAt => text().nullable()();
  TextColumn get createdAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row (id = 1) sync cursors (server-time ISO strings, PLAN §18).
class SyncState extends Table {
  IntColumn get id => integer()();
  TextColumn get lastPullAt => text().nullable()();
  TextColumn get lastPushAt => text().nullable()();
  IntColumn get pendingCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Tenants,
    Categories,
    CategoryTranslations,
    MenuItems,
    MenuItemTranslations,
    MenuItemVariants,
    DeviceAuth,
    SyncState,
  ],
)
class AppDb extends _$AppDb {
  AppDb() : super(_open());

  AppDb.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  static LazyDatabase _open() {
    // sqlite3 v3+ ships its own Android libs; no workaround package needed.
    return LazyDatabase(
      () async => NativeDatabase.createInBackground(File(await _dbFile())),
    );
  }

  /// Kiosk menu: visible categories for [tenantId], display order.
  Future<List<Category>> visibleCategories(String tenantId) {
    return (select(categories)
          ..where(
            (c) =>
                c.tenantId.equals(tenantId) &
                c.isActive.equals(true) &
                c.isDeleted.equals(false),
          )
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder), (c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  /// Kiosk menu: visible items of a category, display order.
  Future<List<MenuItem>> visibleItems(String categoryId) {
    return (select(menuItems)
          ..where(
            (i) =>
                i.categoryId.equals(categoryId) &
                i.isAvailable.equals(true) &
                i.isDeleted.equals(false),
          )
          ..orderBy([(i) => OrderingTerm.asc(i.displayOrder), (i) => OrderingTerm.asc(i.name)]))
        .get();
  }

  Stream<List<Category>> watchVisibleCategories(String tenantId) {
    return (select(categories)
          ..where(
            (c) =>
                c.tenantId.equals(tenantId) &
                c.isActive.equals(true) &
                c.isDeleted.equals(false),
          )
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder), (c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Stream<List<MenuItem>> watchVisibleItems(String categoryId) {
    return (select(menuItems)
          ..where(
            (i) =>
                i.categoryId.equals(categoryId) &
                i.isAvailable.equals(true) &
                i.isDeleted.equals(false),
          )
          ..orderBy([(i) => OrderingTerm.asc(i.displayOrder), (i) => OrderingTerm.asc(i.name)]))
        .watch();
  }

  Stream<List<CategoryTranslation>> watchCategoryTranslations() {
    return select(categoryTranslations).watch();
  }

  Stream<List<MenuItemTranslation>> watchMenuItemTranslations() {
    return select(menuItemTranslations).watch();
  }

  Stream<List<MenuItemVariant>> watchMenuItemVariants() {
    return (select(menuItemVariants)
          ..where((v) => v.isDeleted.equals(false))
          ..orderBy([(v) => OrderingTerm.asc(v.sortOrder)]))
        .watch();
  }
}

Future<String> _dbFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return p.join(dir.path, 'restaurant_menu.db');
}
