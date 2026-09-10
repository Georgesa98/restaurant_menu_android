import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/tenant_config.dart';
import '../../../core/db/app_db.dart';
import '../../../core/i18n/locale_controller.dart';
import '../../../core/sync/image_prefetch.dart';
import '../../../core/theme/web_palette.dart';

/// Pinned brand files (logo/cover), if the pull has pinned them yet.
final _brandFilesProvider =
    FutureProvider<(File?, File?)>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  final prefetch = ImagePrefetch(Dio(), prefs);
  return (
    await prefetch.pinnedBrand('logo'),
    await prefetch.pinnedBrand('cover'),
  );
});

/// Web hero (order-menu.tsx header): eyebrow + script title (or logo),
/// tagline, address/phone. 5-tap on the title opens admin login.
class MenuHero extends ConsumerWidget {
  const MenuHero({super.key, required this.tenant});

  final Tenant? tenant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(localeControllerProvider).languageCode;
    final brand = ref.watch(_brandFilesProvider).value;
    final name = tenant?.name ?? TenantConfig.current.name;
    final description = tenant?.description;
    final logoFile = brand?.$1;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
      child: Column(
        children: [
          Align(
            alignment: locale == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
            child: _LocalePill(),
          ),
          if (logoFile != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(height: 64, child: Image.file(logoFile)),
            )
          else ...[
            Text(
              locale == 'ar' ? 'مطعم' : 'Restaurant',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.35 * 10,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: WebPalette.scriptFont,
                fontSize: 48,
                height: 1.0,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (description?.isNotEmpty == true)
            Text(
              description!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          if ((tenant?.address?.isNotEmpty == true) ||
              (tenant?.phone?.isNotEmpty == true)) ...[
            const SizedBox(height: 12),
            if (tenant?.address?.isNotEmpty == true)
              Text(tenant!.address!, style: _muted(theme)),
            if (tenant?.phone?.isNotEmpty == true)
              Text(
                tenant!.phone!,
                style: _muted(theme),
                textDirection: TextDirection.ltr,
              ),
          ],
        ],
      ),
    );
  }

  TextStyle _muted(ThemeData theme) => TextStyle(
        fontSize: 12,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      );
}

class _LocalePill extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).languageCode;
    return SegmentedButton<String>(
      style: SegmentedButton.styleFrom(visualDensity: VisualDensity.compact),
      segments: const [
        ButtonSegment(value: 'ar', label: Text('عربي')),
        ButtonSegment(value: 'en', label: Text('EN')),
      ],
      selected: {locale},
      onSelectionChanged: (s) =>
          ref.read(localeControllerProvider.notifier).setLocale(s.first),
    );
  }
}
