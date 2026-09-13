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
    final snapshot = ref.watch(lastSyncProvider);
    final email = ref.watch(authControllerProvider).email;
    final menuTid = ref.watch(menuTenantIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
            tooltip: 'Lock',
            icon: const Icon(Icons.lock_outline),
            onPressed: () {
              ref.read(adminUnlockedProvider.notifier).lock();
              context.go('/');
            },
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              ref.read(adminUnlockedProvider.notifier).lock();
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
            title: 'Categories',
            onTap: () => context.go('/admin/categories'),
          ),
          _SectionTile(
            icon: Icons.restaurant_menu_outlined,
            title: 'Menu items',
            onTap: () => context.go('/admin/items'),
          ),
          const Divider(height: 32),
          FilledButton.icon(
            onPressed: snapshot?.running == true
                ? null
                : () => ref.read(syncSchedulerProvider).syncNow(),
            icon: const Icon(Icons.sync),
            label: Text(snapshot?.running == true ? 'Syncing…' : 'Sync now'),
          ),
          const SizedBox(height: 8),
          Text(
            _statusLine(snapshot),
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

  String _statusLine(SyncSnapshot? s) {
    if (s == null) return 'Never synced';
    final time =
        '${s.at.hour.toString().padLeft(2, '0')}:${s.at.minute.toString().padLeft(2, '0')}';
    return switch (s.status) {
      SyncStatus.ok =>
        'Last sync $time • ↓${s.pulledCategories} cat/${s.pulledItems} items • ↑${s.pushed} • ⚠${s.conflicts}',
      SyncStatus.fullRepulled => 'Full re-pull $time • ↓${s.pulledItems} items',
      SyncStatus.offline => 'Offline • last try $time',
      SyncStatus.unauthorized => 'Login expired • reconnect online',
      SyncStatus.serverError => 'Server error • last try $time',
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
    final enabled =
        _value ?? ref.read(screensaverProvider.notifier).enabled;
    return SwitchListTile(
      title: const Text('Attract loop (3 min idle)'),
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
