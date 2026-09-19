import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/tenant_config.dart';
import '../../../core/db/app_db.dart';
import '../../../core/i18n/locale_controller.dart';
import '../../../core/theme/web_palette.dart';
import '../../kiosk/attract_loop.dart' show attractBrandFilesProvider;

/// Pinned brand files (logo/cover), if the pull has pinned them yet.
/// Shared with the attract loop so one override covers both in tests.
FutureProvider<(File?, File?)> _brandFilesProvider = FutureProvider(
  (ref) async {
    final brand = await ref.watch(attractBrandFilesProvider.future);
    return (brand.logo, brand.cover);
  },
);

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
              child: _TitleTapEntry(
                child:
                    SizedBox(height: 64, child: Image.file(logoFile)),
              ),
            )
          else ...[
            Text(
              locale == 'ar' ? 'مطعم' : 'Restaurant',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                // letterSpacing breaks Arabic joining — Latin only.
                letterSpacing: locale == 'ar' ? 0 : 0.35 * 10,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            _TitleTapEntry(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: WebPalette.scriptFont,
                  // AlexBrush is Latin-only; Arabic falls back to Cairo.
                  fontFamilyFallback: const ['Cairo'],
                  fontSize: 48,
                  height: 1.0,
                  color: theme.colorScheme.primary,
                ),
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
          const SizedBox(height: 12),
          _ViewingNotice(locale: locale),
        ],
      ),
    );
  }

  TextStyle _muted(ThemeData theme) => TextStyle(
        fontSize: 12,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      );
}

/// Guest-list notice: the in-app list is not sent to the kitchen —
/// guests show it to the staff.
class _ViewingNotice extends StatelessWidget {
  const _ViewingNotice({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: WebPalette.noticeWash,
        border: Border.all(color: WebPalette.hairline, width: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              locale == 'ar'
                  ? 'قائمتك لا تصل إلى المطبخ — اعرضها على طاقمنا'
                  : 'Your list is not sent to the kitchen — please show it to our staff',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
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

/// Hidden admin entry (backup for the corner hotspot): 5 taps on the brand
/// title/logo within 3s opens admin login. Single taps do nothing visible.
class _TitleTapEntry extends StatefulWidget {
  const _TitleTapEntry({required this.child});

  final Widget child;

  @override
  State<_TitleTapEntry> createState() => _TitleTapEntryState();
}

class _TitleTapEntryState extends State<_TitleTapEntry> {
  static const _need = 5;
  static const _window = Duration(seconds: 3);

  int _taps = 0;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  void _onTap() {
    _reset?.cancel();
    _taps++;
    if (_taps >= _need) {
      _taps = 0;
      context.go('/admin/login');
      return;
    }
    _reset = Timer(_window, () => _taps = 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTap,
      child: widget.child,
    );
  }
}
