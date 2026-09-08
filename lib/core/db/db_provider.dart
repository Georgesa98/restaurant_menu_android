import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/tenant_config.dart';
import 'app_db.dart';
import 'seed_demo.dart';

/// Single [AppDb] for the app lifetime. Seeds demo content on first run when
/// the baked tenant is `demo` and the database is empty (P1 local-data mode;
/// P2 sync replaces the seed with server data).
final appDbProvider = Provider<AppDb>((ref) {
  final db = AppDb();
  ref.onDispose(db.close);
  return db;
});

/// Completes once the database is ready for reads (seeded if applicable).
final dbReadyProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(appDbProvider);
  if (TenantConfig.current.slug != 'demo') return;
  final existing = await (db.select(db.tenants)
        ..where((t) => t.id.equals('demo')))
      .getSingleOrNull();
  if (existing == null) {
    await seedDemo(db);
  }
});
