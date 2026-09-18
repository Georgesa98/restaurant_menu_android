import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/db/app_db.dart';
import 'package:restaurant_menu_android/features/admin/items_admin_page.dart';

Future<String> _seedCategory(AppDb db) async {
  final id = 'cat-1';
  await db.into(db.categories).insert(
        CategoriesCompanion.insert(
          id: id,
          tenantId: 'demo',
          name: 'Grill',
          slug: 'grill',
          updatedAt: '2026-09-14T00:00:00.000Z',
        ),
      );
  return id;
}

Future<void> _seedItem(
  AppDb db, {
  required String id,
  required String catId,
  String? imageUrl,
  bool deleted = false,
}) async {
  await db.into(db.menuItems).insert(
        MenuItemsCompanion.insert(
          id: id,
          tenantId: 'demo',
          categoryId: catId,
          name: 'dish $id',
          imageUrl: Value(imageUrl),
          updatedAt: '2026-09-14T00:00:00.000Z',
          isDeleted: Value(deleted),
        ),
      );
}

void main() {
  late AppDb db;

  setUp(() {
    db = AppDb.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('photoScore', () {
    test('counts missing vs total, ignores deleted', () async {
      final cat = await _seedCategory(db);
      await _seedItem(db, id: 'i1', catId: cat, imageUrl: 'https://x/1.jpg');
      await _seedItem(db, id: 'i2', catId: cat);
      await _seedItem(db, id: 'i3', catId: cat, imageUrl: '   ');
      await _seedItem(db, id: 'i4', catId: cat, deleted: true);

      expect(await db.photoScore('demo'), (2, 3));
    });

    test('empty tenant scores zero', () async {
      expect(await db.photoScore('demo'), (0, 0));
    });
  });

  test('photo filter defaults to off', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(itemsMissingPhotoOnlyProvider), isFalse);
    c.read(itemsMissingPhotoOnlyProvider.notifier).set(true);
    expect(c.read(itemsMissingPhotoOnlyProvider), isTrue);
  });
}
