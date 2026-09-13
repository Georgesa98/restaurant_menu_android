import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';
import '../../features/menu/menu_tenant_id.dart';
import 'data/admin_writes.dart';
import 'widgets/save_and_push.dart';

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

final _categoryTranslationsProvider =
    StreamProvider<List<CategoryTranslation>>((ref) async* {
  await ref.watch(dbReadyProvider.future);
  yield* ref.watch(appDbProvider).watchCategoryTranslations();
});

String? _enName(List<CategoryTranslation> trs, String categoryId) {
  for (final t in trs) {
    if (t.categoryId == categoryId && t.locale == 'en') return t.name;
  }
  return null;
}

/// Categories CRUD: reorder (drag), active toggle, delete, AR+EN dialog.
class CategoriesAdminPage extends ConsumerWidget {
  const CategoriesAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(_allCategoriesProvider).value ?? [];
    final trs = ref.watch(_categoryTranslationsProvider).value ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: cats.isEmpty
          ? const Center(child: Text('No categories — add one'))
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: cats.length,
              onReorderItem: (oldI, newI) async {
                final ordered = cats.map((c) => c.id).toList();
                final moved = ordered.removeAt(oldI);
                ordered.insert(newI, moved);
                await savePushAndToast(
                  ref,
                  context,
                  () => ref.read(adminWritesProvider).reorderCategories(ordered),
                );
              },
              itemBuilder: (_, i) {
                final c = cats[i];
                return ListTile(
                  key: ValueKey(c.id),
                  title: Text(c.name),
                  subtitle: Text(
                    [_enName(trs, c.id), c.slug].whereType<String>().join(' • '),
                  ),
                  leading: const Icon(Icons.drag_handle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: c.isActive,
                        onChanged: (v) => savePushAndToast(
                          ref,
                          context,
                          () => ref.read(adminWritesProvider).setCategoryActive(c.id, v),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openDialog(context, ref, existing: c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDelete(context, ref, c),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Category c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete "${c.name}"?'),
        content: const Text('Its items are hidden too. Syncs to web.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await savePushAndToast(
        ref,
        context,
        () => ref.read(adminWritesProvider).deleteCategory(c.id),
      );
    }
  }

  Future<void> _openDialog(BuildContext context, WidgetRef ref,
      {Category? existing}) async {
    final trs = ref.read(_categoryTranslationsProvider).value ?? [];
    final name = TextEditingController(text: existing?.name ?? '');
    final enName = TextEditingController(
      text: existing == null ? '' : (_enName(trs, existing.id) ?? ''),
    );
    final slug = TextEditingController(text: existing?.slug ?? '');
    final desc = TextEditingController(text: existing?.description ?? '');
    var active = existing?.isActive ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(existing == null ? 'New category' : 'Edit category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Name (Arabic)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: enName,
                  decoration: const InputDecoration(
                    labelText: 'Name (English)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: slug,
                  decoration: const InputDecoration(
                    labelText: 'Slug (auto if empty)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: desc,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Visible'),
                  value: active,
                  onChanged: (v) => setState(() => active = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: name.text.trim().isEmpty
                  ? null
                  : () => Navigator.pop(ctx, true),
              child: const Text('Save'),
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
      () => ref.read(adminWritesProvider).saveCategory(
            id: existing?.id,
            tenantId: tid,
            name: name.text,
            slug: slug.text.trim().isEmpty ? null : slug.text,
            description: desc.text,
            displayOrder: existing?.displayOrder ?? 0,
            isActive: active,
            enName: enName.text,
          ),
    );
  }
}
