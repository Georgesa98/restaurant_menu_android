import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/api/api_client.dart';
import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';
import '../../core/i18n/locale_controller.dart';
import '../../features/menu/menu_format.dart';
import '../../features/menu/menu_tenant_id.dart';
import 'data/admin_writes.dart';
import 'widgets/save_and_push.dart';

final _itemsStreamProvider =
    StreamProvider.autoDispose.family<List<MenuItem>, String>(
  (ref, categoryId) async* {
    await ref.watch(dbReadyProvider.future);
    yield* ref.watch(appDbProvider).watchAllItems(categoryId);
  },
);

final _itemTranslationsProvider =
    StreamProvider<List<MenuItemTranslation>>((ref) async* {
  await ref.watch(dbReadyProvider.future);
  yield* ref.watch(appDbProvider).watchMenuItemTranslations();
});

final _variantsProvider = StreamProvider<List<MenuItemVariant>>((ref) async* {
  await ref.watch(dbReadyProvider.future);
  yield* ref.watch(appDbProvider).watchMenuItemVariants();
});

final _allCategoriesProvider = StreamProvider<List<Category>>((ref) async* {
  await ref.watch(dbReadyProvider.future);
  // Same reactive server uuid as the kiosk (baked id pre-pull).
  final tid = ref.watch(menuTenantIdProvider);
  if (tid.isEmpty) {
    yield [];
    return;
  }
  yield* ref.watch(appDbProvider).watchAllCategories(tid);
});

String? _enName(List<MenuItemTranslation> trs, String itemId) {
  for (final t in trs) {
    if (t.menuItemId == itemId && t.locale == 'en') return t.name;
  }
  return null;
}

/// Items CRUD per category: availability toggle, reorder, AR+EN dialog with
/// variants editor, tags, and dish-photo upload.
class ItemsAdminPage extends ConsumerStatefulWidget {
  const ItemsAdminPage({super.key});

  @override
  ConsumerState<ItemsAdminPage> createState() => _ItemsAdminPageState();
}

class _ItemsAdminPageState extends ConsumerState<ItemsAdminPage> {
  String? _categoryId;

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(_allCategoriesProvider).value ?? [];
    final effectiveCat = cats.any((c) => c.id == _categoryId)
        ? _categoryId
        : (cats.isEmpty ? null : cats.first.id);
    final items = effectiveCat == null
        ? const <MenuItem>[]
        : ref.watch(_itemsStreamProvider(effectiveCat)).value ?? [];
    final trs = ref.watch(_itemTranslationsProvider).value ?? [];
    final vars = ref.watch(_variantsProvider).value ?? [];
    final ar = ref.watch(localeControllerProvider).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(ar ? 'أصناف القائمة' : 'Menu items')),
      floatingActionButton: effectiveCat == null
          ? null
          : FloatingActionButton(
              onPressed: () => _openDialog(context, ref, effectiveCat),
              child: const Icon(Icons.add),
            ),
      body: Column(
        children: [
          if (cats.length > 1)
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButtonFormField<String>(
                initialValue: effectiveCat,
                decoration: InputDecoration(
                  labelText: ar ? 'الصنف' : 'Category',
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  for (final c in cats)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setState(() => _categoryId = v),
              ),
            ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                        ar ? 'لا أطباق — أضف واحدًا' : 'No items — add one'))
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: items.length,
                    onReorderItem: (oldI, newI) async {
                      final ordered = items.map((e) => e.id).toList();
                      final moved = ordered.removeAt(oldI);
                      ordered.insert(newI, moved);
                      await savePushAndToast(
                        ref,
                        context,
                        () => ref.read(adminWritesProvider).reorderItems(ordered),
                      );
                    },
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final vcount =
                          vars.where((v) => v.menuItemId == item.id).length;
                      return ListTile(
                        key: ValueKey(item.id),
                        title: Text(item.name),
                        subtitle: Text(
                          [
                            if ((_enName(trs, item.id)) != null) _enName(trs, item.id)!,
                            if (vcount > 0)
                              (ar ? '$vcount خيارات' : '$vcount variants'),
                            if (item.basePrice != null)
                              formatPrice(item.basePrice),
                          ].join(' • '),
                        ),
                        leading: const Icon(Icons.drag_handle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: item.isAvailable,
                              onChanged: (v) => savePushAndToast(
                                ref,
                                context,
                                () => ref
                                    .read(adminWritesProvider)
                                    .setItemAvailable(item.id, v),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _openDialog(
                                context,
                                ref,
                                effectiveCat!,
                                existing: item,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _confirmDelete(context, ref, item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, MenuItem item) async {
    final ar = ref.read(localeControllerProvider).languageCode == 'ar';
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(ar ? 'حذف "${item.name}"؟' : 'Delete "${item.name}"?'),
        content: Text(ar
            ? 'يختفي من شاشة العرض. تتم المزامنة مع الويب.'
            : 'It disappears from the kiosk. Syncs to web.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(ar ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(ar ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await savePushAndToast(
        ref,
        context,
        () => ref.read(adminWritesProvider).deleteItem(item.id),
      );
    }
  }

  Future<void> _openDialog(
    BuildContext context,
    WidgetRef ref,
    String categoryId, {
    MenuItem? existing,
  }) async {
    final ar = ref.read(localeControllerProvider).languageCode == 'ar';
    final trs = ref.read(_itemTranslationsProvider).value ?? [];
    final vars = ref.read(_variantsProvider).value ?? [];
    final name = TextEditingController(text: existing?.name ?? '');
    final enName = TextEditingController(
      text: existing == null ? '' : (_enName(trs, existing.id) ?? ''),
    );
    final desc = TextEditingController(text: existing?.description ?? '');
    final price = TextEditingController(
      text: existing?.basePrice?.toString() ?? '',
    );
    final tags = TextEditingController(
      text: (existing?.dietaryTagsCsv ?? '').split('|').where((t) => t.isNotEmpty).join(', '),
    );
    final imageUrl = TextEditingController(text: existing?.imageUrl ?? '');
    final variantRows = <_VariantRow>[
      for (final v in vars.where((v) => v.menuItemId == existing?.id))
        _VariantRow(
          label: TextEditingController(text: v.label),
          labelEn: TextEditingController(text: v.labelEn),
          price: TextEditingController(text: v.price.toString()),
        ),
    ];
    var available = existing?.isAvailable ?? true;
    var uploading = false;

    Future<void> pickAndUpload(StateSetter setState) async {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => uploading = true);
      try {
        final url = await ref
            .read(apiClientProvider)
            .uploadDishPhoto(picked.path, picked.name);
        imageUrl.text = url;
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ar
                  ? 'الرفع يحتاج إنترنت — الرابط لم يتغير'
                  : 'Upload needs internet — URL unchanged'),
            ),
          );
        }
      } finally {
        if (context.mounted) setState(() => uploading = false);
      }
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null
              ? (ar ? 'طبق جديد' : 'New item')
              : (ar ? 'تعديل الطبق' : 'Edit item')),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: ar ? 'الاسم (بالعربية)' : 'Name (Arabic)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: enName,
                    decoration: InputDecoration(
                      labelText: ar ? 'الاسم (بالإنجليزية)' : 'Name (English)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: desc,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: ar ? 'الوصف' : 'Description',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: price,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: ar
                          ? 'السعر الأساسي (يُخفى عند وجود خيارات)'
                          : 'Base price (hidden when variants exist)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tags,
                    decoration: InputDecoration(
                      labelText:
                          ar ? 'الوسوم (مفصولة بفواصل)' : 'Tags (comma separated)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: imageUrl,
                          decoration: InputDecoration(
                            labelText: ar ? 'رابط الصورة (4:3)' : 'Photo URL (4:3)',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      uploading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              tooltip: ar ? 'رفع صورة' : 'Upload photo',
                              icon: const Icon(Icons.upload),
                              onPressed: () => pickAndUpload(setState),
                            ),
                    ],
                  ),
                  SwitchListTile(
                    title: Text(ar ? 'متوفر' : 'Available'),
                    value: available,
                    onChanged: (v) => setState(() => available = v),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ar ? 'الخيارات (اختياري)' : 'Variants (optional)'),
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: Text(ar ? 'إضافة' : 'Add'),
                        onPressed: () => setState(
                          () => variantRows.add(_VariantRow.empty()),
                        ),
                      ),
                    ],
                  ),
                  for (var i = 0; i < variantRows.length; i++)
                    _VariantEditor(
                      key: ValueKey('variant-$i'),
                      row: variantRows[i],
                      ar: ar,
                      onRemove: () =>
                          setState(() => variantRows.removeAt(i)),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ar ? 'إلغاء' : 'Cancel'),
            ),
            FilledButton(
              onPressed:
                  name.text.trim().isEmpty ? null : () => Navigator.pop(ctx, true),
              child: Text(ar ? 'حفظ' : 'Save'),
            ),
          ],
        ),
      ),
    );
    if (saved != true || !context.mounted) return;
    final tid = await resolveWriteTenantId(ref.read(secureStorageProvider));
    if (!context.mounted) return;
    await savePushAndToast(
      ref,
      context,
      () => ref.read(adminWritesProvider).saveItem(
            id: existing?.id,
            tenantId: tid,
            categoryId: categoryId,
            name: name.text,
            description: desc.text,
            basePrice: double.tryParse(price.text.trim()),
            imageUrl: imageUrl.text,
            isAvailable: available,
            displayOrder: existing?.displayOrder ?? 0,
            dietaryTags: tags.text
                .split(',')
                .map((t) => t.trim())
                .where((t) => t.isNotEmpty)
                .toList(),
            enName: enName.text,
            variants: [
              for (final r in variantRows)
                if (r.label.text.trim().isNotEmpty)
                  VariantInput(
                    label: r.label.text,
                    labelEn: r.labelEn.text,
                    price: double.tryParse(r.price.text.trim()) ?? 0,
                  ),
            ],
          ),
    );
  }
}

class _VariantRow {
  _VariantRow({required this.label, required this.labelEn, required this.price});
  _VariantRow.empty()
      : label = TextEditingController(),
        labelEn = TextEditingController(),
        price = TextEditingController();
  final TextEditingController label;
  final TextEditingController labelEn;
  final TextEditingController price;
}

class _VariantEditor extends StatelessWidget {
  const _VariantEditor(
      {super.key, required this.row, required this.ar, required this.onRemove});

  final _VariantRow row;
  final bool ar;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: row.label,
              decoration: InputDecoration(
                labelText: ar ? 'التسمية (عربي)' : 'Label (AR)',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: TextField(
              controller: row.labelEn,
              decoration: InputDecoration(
                labelText: ar ? 'التسمية (إنجليزي)' : 'Label (EN)',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: TextField(
              controller: row.price,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: ar ? 'السعر' : 'Price',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
