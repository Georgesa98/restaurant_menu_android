import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/locale_controller.dart';
import '../../core/sync/sync_engine.dart';
import '../../core/sync/sync_scheduler.dart';

/// P2: pull status + manual "Sync now". P3 adds CRUD here (PLAN §7/§8).
class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final snapshot = ref.watch(lastSyncProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Admin (P3) • locale: ${locale.languageCode}'),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ar', label: Text('عربي')),
                ButtonSegment(value: 'en', label: Text('EN')),
              ],
              selected: {locale.languageCode},
              onSelectionChanged: (s) =>
                  ref.read(localeControllerProvider.notifier).setLocale(s.first),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: snapshot?.running == true
                  ? null
                  : () => ref.read(syncSchedulerProvider).syncNow(),
              icon: const Icon(Icons.sync),
              label: Text(
                snapshot?.running == true ? 'Syncing…' : 'Sync now',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _statusLine(snapshot),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

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

