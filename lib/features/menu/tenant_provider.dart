import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/tenant_config.dart';
import '../../core/db/app_db.dart';
import '../../core/db/db_provider.dart';

/// Shared tenant row for menu home + category detail (avoids duplication).
final tenantRowProvider = StreamProvider<Tenant?>((ref) async* {
  await ref.watch(dbReadyProvider.future);
  yield* ref
      .watch(appDbProvider)
      .watchTenantBySlug(TenantConfig.current.slug);
});
