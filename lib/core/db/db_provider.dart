import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/tenant_config.dart';
import 'app_db.dart';
import 'seed_tenant.dart';

/// Single [AppDb] for the app lifetime. Seeds the demo tenant from the bundled
/// valley-star dataset on first run (PLAN §24); other tenants start empty and
/// fill on first pull (which replaces seed rows, §18).
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
    await seedTenantFromAsset(
      db,
      assetPath: 'assets/seed/demo.json',
      tenantId: 'demo',
      slug: 'demo',
      name: TenantConfig.current.name,
    );
  }
});
