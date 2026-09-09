import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/tenant_config.dart';
import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/sync/image_prefetch.dart';

class _Dish {
  const _Dish({required this.name, required this.imageUrl});
  final String name;
  final String imageUrl;
}

class _AttractData {
  const _AttractData({
    required this.tenantName,
    required this.logo,
    required this.cover,
    required this.dishes,
  });
  final String tenantName;
  final File? logo;
  final File? cover;
  final List<_Dish> dishes;
}

/// Cover + logo + top dishes with photos. Any tap dismisses (route pop).
final _attractDataProvider = FutureProvider<_AttractData>((ref) async {
  final db = ref.watch(appDbProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final prefetch = ImagePrefetch(Dio(), prefs);
  final slug = TenantConfig.current.slug;
  final tid = TenantConfig.current.tenantId.isNotEmpty
      ? TenantConfig.current.tenantId
      : (slug == 'demo' ? 'demo' : '');

  final locale = ref.watch(localeControllerProvider).languageCode;
  final items = tid.isEmpty ? <MenuItem>[] : await db.topItemsWithImages(tid, 12);
  final withPhotos = items.where((i) => i.imageUrl?.isNotEmpty == true).take(6).toList();

  List<MenuItemTranslation> trs = [];
  if (withPhotos.isNotEmpty) {
    trs = await (db.select(db.menuItemTranslations)
          ..where((t) => t.menuItemId.isIn(withPhotos.map((i) => i.id).toList())))
        .get();
  }
  String nameOf(MenuItem i) {
    for (final t in trs) {
      if (t.menuItemId == i.id && t.locale == locale && t.name.trim().isNotEmpty) {
        return t.name;
      }
    }
    return i.name;
  }

  return _AttractData(
    tenantName: TenantConfig.current.name,
    logo: await prefetch.pinnedBrand('logo'),
    cover: await prefetch.pinnedBrand('cover'),
    dishes: [for (final i in withPhotos) _Dish(name: nameOf(i), imageUrl: i.imageUrl!)],
  );
});

class AttractLoopOverlay extends ConsumerWidget {
  const AttractLoopOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(_attractDataProvider).value;
    final theme = Theme.of(context);
    final locale = ref.watch(localeControllerProvider).languageCode;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: data == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (data.cover != null)
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: Image.file(data.cover!, fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 24),
                  if (data.logo != null)
                    SizedBox(
                      height: 120,
                      child: Image.file(data.logo!),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      data.tenantName,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  if (data.dishes.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 4 / 3,
                        ),
                        itemCount: data.dishes.length,
                        itemBuilder: (_, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: data.dishes[i].imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, _, _) =>
                                    Container(color: theme.colorScheme.surfaceContainerHighest),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.black54,
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    data.dishes[i].name,
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      locale == 'ar' ? 'المس للتصفح' : 'Touch to browse',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
