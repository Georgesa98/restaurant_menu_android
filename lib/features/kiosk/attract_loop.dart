import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/tenant_config.dart';
import '../../core/db/db_provider.dart';
import '../../core/i18n/locale_controller.dart';
import '../../core/sync/image_prefetch.dart';
import '../../core/theme/web_palette.dart';
import '../menu/menu_tenant_id.dart';

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

class _AttractData {
  const _AttractData({
    required this.tenantName,
    required this.logo,
    required this.cover,
  });
  final String tenantName;
  final File? logo;
  final File? cover;
}

/// Full-bleed brand hero: big centered logo + restaurant name, touch pill at
/// the bottom. Any tap dismisses (route pop). Static by design — no timers,
/// no rotation, no dish grid.
final _attractDataProvider = FutureProvider<_AttractData>((ref) async {
  final db = ref.watch(appDbProvider);
  // Server uuid once pulled (baked id before) — same source as the menu.
  final tid = ref.watch(menuTenantIdProvider);

  // Brand files are optional decoration: a pin-dir failure must never blank
  // the loop (e.g. path_provider unavailable in tests).
  final brand = await ref.watch(attractBrandFilesProvider.future);
  final File? logo = brand.logo;
  final File? cover = brand.cover;

  var tenantName = TenantConfig.current.name;
  if (tid.isNotEmpty) {
    final tenant = await (db.select(db.tenants)
          ..where((t) => t.id.equals(tid))
          ..limit(1))
        .getSingleOrNull();
    if (tenant != null) {
      tenantName = tenant.name;
    }
  }

  return _AttractData(
    tenantName: tenantName,
    logo: logo,
    cover: cover,
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

/// Same hero skeleton, rendered instantly from sync config while the
/// provider resolves — never a bare spinner.
class _LoadingFrame extends StatelessWidget {
  const _LoadingFrame();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        children: [
          const Spacer(flex: 3),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            TenantConfig.current.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: WebPalette.scriptFont,
              fontFamilyFallback: ['Cairo'],
              fontSize: 76,
              height: 1.0,
              color: Colors.white,
            ),
          ),
          const Spacer(flex: 4),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        children: [
          const Spacer(flex: 3),
          if (data.logo != null)
            SizedBox(
              height: 180,
              child: Image.file(data.logo!, fit: BoxFit.contain),
            ),
          if (data.logo != null) const SizedBox(height: 24),
          Text(
            locale == 'ar' ? 'مطعم' : 'Restaurant',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              // letterSpacing breaks Arabic joining — Latin only.
              letterSpacing: locale == 'ar' ? 0 : 3.5,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.tenantName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: WebPalette.scriptFont,
              // AlexBrush is Latin-only; Arabic falls back to Cairo.
              fontFamilyFallback: ['Cairo'],
              fontSize: 76,
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
          const Spacer(flex: 4),
          _CtaPill(
            label: locale == 'ar' ? 'المس للتصفح' : 'Touch to browse',
            color: theme.colorScheme.primary,
          ),
        ],
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
