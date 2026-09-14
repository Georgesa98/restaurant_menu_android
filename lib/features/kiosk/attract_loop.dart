import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/config/tenant_config.dart';
import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/sync/image_prefetch.dart';
import '../../core/theme/web_palette.dart';
import '../menu/menu_format.dart';
import '../menu/menu_tenant_id.dart';

class _Dish {
  const _Dish({
    required this.name,
    required this.imageUrl,
    required this.priceLabel,
  });
  final String name;
  final String imageUrl;
  final String priceLabel;
}

class _AttractData {
  const _AttractData({
    required this.tenantName,
    this.description,
    this.address,
    this.phone,
    required this.logo,
    required this.cover,
    required this.dishes,
  });
  final String tenantName;
  final String? description;
  final String? address;
  final String? phone;
  final File? logo;
  final File? cover;
  final List<_Dish> dishes;
}

/// Pinned brand files (logo/cover). Separate provider so widget tests can
/// override with `(null, null)` — path_provider has no test implementation
/// and would otherwise leave [_attractDataProvider] in loading forever.
/// Production timeout guards a platform channel that never resolves.
final attractBrandFilesProvider =
    FutureProvider<({File? logo, File? cover})>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  try {
    final prefetch = ImagePrefetch(Dio(), prefs);
    final logo = await prefetch
        .pinnedBrand('logo')
        .timeout(const Duration(seconds: 2), onTimeout: () => null);
    final cover = await prefetch
        .pinnedBrand('cover')
        .timeout(const Duration(seconds: 2), onTimeout: () => null);
    return (logo: logo, cover: cover);
  } catch (_) {
    return (logo: null, cover: null);
  }
});

/// Full-bleed brand frame + featured dishes with prices. Any tap dismisses
/// (route pop). Static by design — no timers, no rotation.
final _attractDataProvider = FutureProvider<_AttractData>((ref) async {
  final db = ref.watch(appDbProvider);
  // Server uuid once pulled (baked id before) — same source as the menu.
  final tid = ref.watch(menuTenantIdProvider);

  final locale = ref.watch(localeControllerProvider).languageCode;

  // Brand files are optional decoration: a pin-dir failure must never blank
  // the loop (e.g. path_provider unavailable in tests).
  final brand = await ref.watch(attractBrandFilesProvider.future);
  final File? logo = brand.logo;
  final File? cover = brand.cover;

  var tenantName = TenantConfig.current.name;
  String? description;
  String? address;
  String? phone;
  List<MenuItem> items = const [];
  if (tid.isNotEmpty) {
    final tenant = await (db.select(db.tenants)
          ..where((t) => t.id.equals(tid))
          ..limit(1))
        .getSingleOrNull();
    if (tenant != null) {
      tenantName = tenant.name;
      description = tenant.description;
      address = tenant.address;
      phone = tenant.phone;
    }
    items = await db.topItemsWithImages(tid, 12);
  }
  final withPhotos =
      items.where((i) => i.imageUrl?.isNotEmpty == true).take(6).toList();

  final ids = withPhotos.map((i) => i.id).toList();
  List<MenuItemTranslation> trs = [];
  final variantPrices = <String, List<double>>{};
  if (ids.isNotEmpty) {
    trs = await (db.select(db.menuItemTranslations)
          ..where((t) => t.menuItemId.isIn(ids)))
        .get();
    final vars = await (db.select(db.menuItemVariants)
          ..where((v) => v.menuItemId.isIn(ids))
          ..where((v) => v.isDeleted.equals(false)))
        .get();
    for (final v in vars) {
      (variantPrices[v.menuItemId] ??= []).add(v.price);
    }
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
    tenantName: tenantName,
    description: description,
    address: address,
    phone: phone,
    logo: logo,
    cover: cover,
    dishes: [
      for (final i in withPhotos)
        _Dish(
          name: nameOf(i),
          imageUrl: i.imageUrl!,
          priceLabel: displayPrice(
            basePrice: i.basePrice,
            variantPrices: variantPrices[i.id] ?? const [],
            selectedIndex: -1,
            locale: locale,
          ),
        ),
    ],
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
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (data?.cover != null)
              Image.file(data!.cover!, fit: BoxFit.cover)
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.55),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            // Scrim: keeps brand text legible over any cover photo.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xD9000000),
                    Color(0x40000000),
                    Color(0x00000000),
                    Color(0x66000000),
                    Color(0xE6000000),
                  ],
                  stops: [0.0, 0.28, 0.5, 0.75, 1.0],
                ),
              ),
            ),
            SafeArea(
              child: data == null
                  ? const _LoadingFrame()
                  : _LoadedFrame(data: data, locale: locale),
            ),
          ],
        ),
      ),
    );
  }
}

/// Same frame skeleton, rendered instantly from sync config while the
/// provider resolves — never a bare spinner.
class _LoadingFrame extends StatelessWidget {
  const _LoadingFrame();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            TenantConfig.current.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: WebPalette.scriptFont,
              fontFamilyFallback: ['Cairo'],
              fontSize: 48,
              height: 1.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (_, i) => AspectRatio(
                aspectRatio: i == 0 ? 4 / 5 : 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const _CtaPill(label: ''),
        ],
      ),
    );
  }
}

class _LoadedFrame extends StatelessWidget {
  const _LoadedFrame({required this.data, required this.locale});

  final _AttractData data;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contact = [
      if (data.address?.trim().isNotEmpty == true) data.address!.trim(),
      if (data.phone?.trim().isNotEmpty == true) data.phone!.trim(),
    ].join('  •  ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        children: [
          if (data.logo != null)
            SizedBox(height: 72, child: Image.file(data.logo!)),
          Text(
            locale == 'ar' ? 'مطعم' : 'Restaurant',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              // letterSpacing breaks Arabic joining — Latin only.
              letterSpacing: locale == 'ar' ? 0 : 3.5,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.tenantName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: WebPalette.scriptFont,
              // AlexBrush is Latin-only; Arabic falls back to Cairo.
              fontFamilyFallback: ['Cairo'],
              fontSize: 52,
              height: 1.0,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 12,
                  color: Color(0x80000000),
                ),
              ],
            ),
          ),
          if (data.description?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              data.description!.trim(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ],
          if (contact.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              contact,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.62),
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (data.dishes.isNotEmpty)
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.dishes.length,
                itemBuilder: (_, i) =>
                    _DishCard(dish: data.dishes[i], tall: i == 0),
              ),
            )
          else
            const Spacer(),
          const SizedBox(height: 16),
          _CtaPill(
            label: locale == 'ar' ? 'المس للتصفح' : 'Touch to browse',
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _DishCard extends StatelessWidget {
  const _DishCard({required this.dish, required this.tall});

  final _Dish dish;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: tall ? 4 / 5 : 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _DishPhoto(url: dish.imageUrl),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xB3000000)],
                  stops: [0.45, 1.0],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        dish.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (dish.priceLabel.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          dish.priceLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cache-first dish photo: disk-cache hit renders instantly with no network;
/// otherwise fall back to a cached-network fetch with a themed placeholder.
/// Keeps the idle kiosk complete when offline.
class _DishPhoto extends StatelessWidget {
  const _DishPhoto({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FileInfo?>(
      future: DefaultCacheManager().getFileFromCache(url),
      builder: (context, snapshot) {
        final file = snapshot.data?.file;
        if (file != null) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const _PhotoFallback(),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _PhotoFallback();
        }
        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          memCacheWidth: 600,
          placeholder: (_, _) => const _PhotoFallback(),
          errorWidget: (_, _, _) => const _PhotoFallback(),
        );
      },
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WebPalette.imageWash,
      alignment: Alignment.center,
      child: Icon(
        Icons.restaurant,
        size: 32,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      ),
    );
  }
}

class _CtaPill extends StatelessWidget {
  const _CtaPill({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Colors.white.withValues(alpha: 0.16);
    final fg = color != null
        ? Theme.of(context).colorScheme.onPrimary
        : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 16,
            color: Color(0x40000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app, color: fg),
          const SizedBox(width: 10),
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Container(
              width: 120,
              height: 17,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
        ],
      ),
    );
  }
}
