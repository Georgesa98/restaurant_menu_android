import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sync/sync_engine.dart';
import '../../../core/sync/sync_scheduler.dart';

/// Runs an admin write, pushes, and toasts the result.
/// Server-wins conflicts surface as "kept newest from web" (PLAN §7).
Future<void> savePushAndToast(
  WidgetRef ref,
  BuildContext context,
  Future<void> Function() write,
) async {
  await write();
  if (!context.mounted) return;
  final outcome = await ref.read(syncSchedulerProvider).syncNow();
  if (!context.mounted) return;
  final message = switch (outcome.status) {
    SyncStatus.offline => 'Saved locally • will push when online',
    SyncStatus.unauthorized => 'Saved locally • log in to push',
    SyncStatus.serverError => 'Saved locally • push failed, will retry',
    _ => outcome.conflicts > 0
        ? 'Saved • web had newer edits (kept newest)'
        : 'Saved • pushed ↑${outcome.pushed}',
  };
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
