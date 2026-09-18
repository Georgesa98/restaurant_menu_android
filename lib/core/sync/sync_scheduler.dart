import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/tenant_config.dart';
import '../db/db_provider.dart';
import '../i18n/locale_controller.dart';
import 'heartbeat.dart';
import 'image_prefetch.dart';
import 'sync_engine.dart';

/// Last completed (or failed) sync cycle, shown in admin (docs/PLAN.md §7).
class SyncSnapshot {
  const SyncSnapshot({
    required this.status,
    required this.at,
    this.pulledCategories = 0,
    this.pulledItems = 0,
    this.pushed = 0,
    this.conflicts = 0,
    this.running = false,
  });

  final SyncStatus status;
  final DateTime at;
  final int pulledCategories;
  final int pulledItems;
  final int pushed;
  final int conflicts;
  final bool running;
}

class _LastSync extends Notifier<SyncSnapshot?> {
  @override
  SyncSnapshot? build() => null;

  void setRunning() {
    state = SyncSnapshot(status: SyncStatus.ok, at: DateTime.now(), running: true);
  }

  void set(SyncOutcome outcome) {
    state = SyncSnapshot(
      status: outcome.status,
      at: DateTime.now(),
      pulledCategories: outcome.pulledCategories,
      pulledItems: outcome.pulledItems,
      pushed: outcome.pushed,
      conflicts: outcome.conflicts,
    );
  }
}

final lastSyncProvider =
    NotifierProvider<_LastSync, SyncSnapshot?>(_LastSync.new);

/// 15-min periodic pull/push + boot pull + image prefetch (docs/PLAN.md §7).
/// Started once from [MenuApp]; manual runs via [syncNow].
class SyncScheduler {
  SyncScheduler(this._ref);

  final Ref _ref;
  Timer? _timer;
  bool _started = false;
  bool _busy = false;

  static const interval = Duration(minutes: 15);

  void start() {
    if (_started) return;
    _started = true;
    unawaited(syncNow());
    _timer = Timer.periodic(interval, (_) => unawaited(syncNow()));
  }

  void dispose() => _timer?.cancel();

  Future<SyncOutcome> syncNow() async {
    if (_busy) {
      return const SyncOutcome(SyncStatus.ok);
    }
    _busy = true;
    _ref.read(lastSyncProvider.notifier).setRunning();
    try {
      final engine = _ref.read(syncEngineProvider);
      final outcome = await engine.syncNow();
      _ref.read(lastSyncProvider.notifier).set(outcome);
      if (outcome.status == SyncStatus.ok ||
          outcome.status == SyncStatus.fullRepulled) {
        await _postPullMedia();
      }
      // Liveness + catch-up (PLAN §31): the server may have moved between
      // our push and pull. Best-effort — never fails the cycle.
      await _heartbeatCatchUp();
      return outcome;
    } finally {
      _busy = false;
    }
  }

  /// Sends the heartbeat with our just-pulled revision; when the server
  /// reports a newer revision, performs one more delta pull. No loop: a
  /// single catch-up is enough per cycle (the next 15-min tick covers races).
  Future<void> _heartbeatCatchUp() async {
    try {
      final db = _ref.read(appDbProvider);
      final known = await localRevision(db, TenantConfig.current.slug);
      final hb = await sendHeartbeat(_ref, knownRevision: known);
      if (hb == null || hb.revision <= known) return;
      final outcome = await _ref.read(syncEngineProvider).pull();
      _ref.read(lastSyncProvider.notifier).set(outcome);
      if (outcome.status == SyncStatus.ok ||
          outcome.status == SyncStatus.fullRepulled) {
        await _postPullMedia();
      }
    } catch (_) {
      // Heartbeat never fails sync.
    }
  }

  /// Cache dish photos + re-pin logo/cover after a successful pull.
  Future<void> _postPullMedia() async {
    try {
      final db = _ref.read(appDbProvider);
      final prefs = _ref.read(sharedPreferencesProvider);
      final prefetch = ImagePrefetch(Dio(), prefs);

      final items = await (db.select(db.menuItems)
            ..where((i) => i.isDeleted.equals(false)))
          .get();
      await prefetch.prefetchDishes(
        [for (final i in items) if (i.imageUrl?.isNotEmpty == true) i.imageUrl!],
      );

      final tenant = await (db.select(db.tenants)).getSingleOrNull();
      await prefetch.pinBrand(logoUrl: tenant?.logoUrl, coverUrl: tenant?.coverUrl);
    } catch (_) {
      // Media is best-effort; sync data already applied.
    }
  }
}

final syncSchedulerProvider = Provider<SyncScheduler>((ref) {
  final scheduler = SyncScheduler(ref);
  ref.onDispose(scheduler.dispose);
  return scheduler;
});
