import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/locale_controller.dart';
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_scheduler.dart';
import '../../features/menu/menu_tenant_id.dart';
import '../kiosk/screensaver_controller.dart';
import 'auth/admin_auth.dart';

/// Admin hub: sections, sync status + manual push, locale, logout.
class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final ar = locale.languageCode == 'ar';
    final snapshot = ref.watch(lastSyncProvider);
    final email = ref.watch(authControllerProvider.select((s) => s.email));
    final menuTid = ref.watch(menuTenantIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(ar ? 'الإدارة' : 'Admin'),
        actions: [
          IconButton(
            tooltip: ar ? 'قفل' : 'Lock',
            icon: const Icon(Icons.lock_outline),
            onPressed: () {
              ref.read(adminUnlockedProvider.notifier).lock();
              context.go('/');
            },
          ),
          IconButton(
            tooltip: ar ? 'تسجيل الخروج' : 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // logout() already locks the admin gate.
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/admin/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (email != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(email, style: Theme.of(context).textTheme.bodySmall),
            ),
          _SectionTile(
            icon: Icons.category_outlined,
            title: ar ? 'الأصناف' : 'Categories',
            onTap: () => context.go('/admin/categories'),
          ),
          _SectionTile(
            icon: Icons.restaurant_menu_outlined,
            title: ar ? 'أصناف القائمة' : 'Menu items',
            onTap: () => context.go('/admin/items'),
          ),
          const Divider(height: 32),
          FilledButton.icon(
            onPressed: snapshot?.running == true
                ? null
                : () => ref.read(syncSchedulerProvider).syncNow(),
            icon: const Icon(Icons.sync),
            label: Text(snapshot?.running == true
                ? (ar ? 'جارٍ المزامنة…' : 'Syncing…')
                : (ar ? 'مزامنة الآن' : 'Sync now')),
          ),
          const SizedBox(height: 8),
          Text(
            _statusLine(snapshot, ar),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            // Queried tenant id (server uuid post-pull): makes menu/admin
            // identity mismatches self-evident on-device.
            'tenant ${menuTid.isEmpty ? '—' : _shortId(menuTid)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Divider(height: 32),
          SegmentedButton<String>(            segments: const [
              ButtonSegment(value: 'ar', label: Text('عربي')),
              ButtonSegment(value: 'en', label: Text('EN')),
            ],
            selected: {locale.languageCode},
            onSelectionChanged: (s) =>
                ref.read(localeControllerProvider.notifier).setLocale(s.first),
          ),
          const SizedBox(height: 8),
          const _ScreensaverToggle(),
        ],
      ),
    );
  }

  String _shortId(String id) =>
      id.length > 8 ? '${id.substring(0, 8)}…' : id;

  String _statusLine(SyncSnapshot? s, bool ar) {
    if (s == null) return ar ? 'لم تتم المزامنة بعد' : 'Never synced';
    final time =
        '${s.at.hour.toString().padLeft(2, '0')}:${s.at.minute.toString().padLeft(2, '0')}';
    return switch (s.status) {
      SyncStatus.ok => ar
        ? 'آخر مزامنة $time • ↓${s.pulledCategories} أصناف/${s.pulledItems} أطباق • ↑${s.pushed} • ⚠${s.conflicts}'
        : 'Last sync $time • ↓${s.pulledCategories} cat/${s.pulledItems} items • ↑${s.pushed} • ⚠${s.conflicts}',
      SyncStatus.fullRepulled => ar
        ? 'إعادة سحب كاملة $time • ↓${s.pulledItems} أطباق'
        : 'Full re-pull $time • ↓${s.pulledItems} items',
      SyncStatus.offline =>
        ar ? 'غير متصل • آخر محاولة $time' : 'Offline • last try $time',
      SyncStatus.unauthorized => ar
        ? 'انتهت الجلسة • أعد الاتصال بالإنترنت'
        : 'Login expired • reconnect online',
      SyncStatus.serverError =>
        ar ? 'خطأ في الخادم • آخر محاولة $time' : 'Server error • last try $time',
    };
  }
}

/// Idle attract loop on/off (3-min timer, docs/PLAN.md §15).
class _ScreensaverToggle extends ConsumerStatefulWidget {
  const _ScreensaverToggle();

  @override
  ConsumerState<_ScreensaverToggle> createState() => _ScreensaverToggleState();
}

class _ScreensaverToggleState extends ConsumerState<_ScreensaverToggle> {
  bool? _value;

  @override
  Widget build(BuildContext context) {
    final ar =
        ref.watch(localeControllerProvider).languageCode == 'ar';
    final enabled =
        _value ?? ref.read(screensaverProvider.notifier).enabled;
    return SwitchListTile(
      title: Text(ar ? 'شاشة الجذب (بعد 3 دقائق خمول)' : 'Attract loop (3 min idle)'),
      value: enabled,
      onChanged: (v) async {
        await ref.read(screensaverProvider.notifier).setEnabled(v);
        setState(() => _value = v);
      },
    );
  }
}

class _SectionTile extends StatelessWidget {  const _SectionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
