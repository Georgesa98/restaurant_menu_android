import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/locale_controller.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/sync/sync_scheduler.dart';
import '../auth/admin_auth.dart';

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
  if (outcome.status == SyncStatus.unauthorized) {
    // Session expired server-side: wipe, lock admin, force online re-login.
    await ref.read(authControllerProvider.notifier).forceRelogin();
    if (!context.mounted) return;
  }
  final ar = ref.read(localeControllerProvider).languageCode == 'ar';
  final message = switch (outcome.status) {
    SyncStatus.offline => ar
        ? 'حُفظ محليًا • سيُرفع عند الاتصال'
        : 'Saved locally • will push when online',
    SyncStatus.unauthorized =>
      ar ? 'حُفظ محليًا • سجّل الدخول للرفع' : 'Saved locally • log in to push',
    SyncStatus.serverError => ar
        ? 'حُفظ محليًا • فشل الرفع، ستُعاد المحاولة'
        : 'Saved locally • push failed, will retry',
    _ => outcome.conflicts > 0
        ? (ar
            ? 'حُفظ • الويب كان لديه تعديلات أحدث (اعتُمد الأحدث)'
            : 'Saved • web had newer edits (kept newest)')
        : (ar
            ? 'حُفظ • رُفع ↑${outcome.pushed}'
            : 'Saved • pushed ↑${outcome.pushed}'),
  };
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
