import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/features/admin/data/admin_writes.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';

void main() {
  late AppDb db;
  late AdminWrites writes;

  setUp(() {
    db = AppDb.forTesting(NativeDatabase.memory());
    writes = AdminWrites(db);
  });

  tearDown(() => db.close());

  group('slugify', () {
    test('latin names slug cleanly', () {
      expect(slugify('Grill House'), 'grill-house');
    });

    test('non-latin falls back to timestamp id', () {
      expect(slugify('مشاوي'), startsWith('item-'));
    });
  });

  group('categories', () {
    test('save marks dirty with EN translation', () async {
      final id = await writes.saveCategory(
        tenantId: 'demo',
        name: 'مشاوي',
        enName: 'Grill',
      );
      final cat = await (db.select(db.categories)..where((c) => c.id.equals(id))).getSingle();
      expect(cat.dirty, isTrue);
      expect(cat.slug, startsWith('item-'));
      final trs = await (db.select(db.categoryTranslations)).get();
      expect(trs.single.name, 'Grill');
    });

    test('delete flags category and items', () async {
      final cid = await writes.saveCategory(tenantId: 'demo', name: 'x');
      await writes.saveItem(
        tenantId: 'demo',
        categoryId: cid,
        name: 'y',
      );
      await writes.deleteCategory(cid);

      final cat = await (db.select(db.categories)..where((c) => c.id.equals(cid))).getSingle();
      expect(cat.isDeleted, isTrue);
      expect(cat.dirty, isTrue);
      final items = await (db.select(db.menuItems)).get();
      expect(items.single.isDeleted, isTrue);
      expect(items.single.dirty, isTrue);
    });

    test('reorder rewrites display order', () async {
      final a = await writes.saveCategory(tenantId: 'demo', name: 'a');
      final b = await writes.saveCategory(tenantId: 'demo', name: 'b');
      await writes.reorderCategories([b, a]);
      final cats = await (db.select(db.categories)
            ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
          .get();
      expect(cats.map((c) => c.id), [b, a]);
    });
  });

  group('items', () {
    test('save with variants tombstones old set on resave', () async {
      final cid = await writes.saveCategory(tenantId: 'demo', name: 'c');
      final iid = await writes.saveItem(
        tenantId: 'demo',
        categoryId: cid,
        name: 'k',
        variants: const [VariantInput(label: 'نصف', price: 90)],
      );
      await writes.saveItem(
        id: iid,
        tenantId: 'demo',
        categoryId: cid,
        name: 'k',
        variants: const [VariantInput(label: 'كيلو', price: 180)],
      );
      final vars = await (db.select(db.menuItemVariants)
            ..where((v) => v.menuItemId.equals(iid) & v.isDeleted.equals(false)))
          .get();
      expect(vars, hasLength(1));
      expect(vars.single.label, 'كيلو');
      final item = await (db.select(db.menuItems)..where((i) => i.id.equals(iid))).getSingle();
      expect(item.dirty, isTrue);
    });

    test('availability toggle marks dirty', () async {
      final cid = await writes.saveCategory(tenantId: 'demo', name: 'c');
      final iid = await writes.saveItem(tenantId: 'demo', categoryId: cid, name: 'k');
      // clear dirty to prove the toggle re-marks it
      await (db.update(db.menuItems)..where((i) => i.id.equals(iid)))
          .write(const MenuItemsCompanion(dirty: Value(false)));
      await writes.setItemAvailable(iid, false);
      final item = await (db.select(db.menuItems)..where((i) => i.id.equals(iid))).getSingle();
      expect(item.isAvailable, isFalse);
      expect(item.dirty, isTrue);
    });
  });
}
