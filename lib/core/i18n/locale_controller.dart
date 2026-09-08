import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provided as an override in `main()` with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('override in main()'),
);

/// UI locale. Default `ar` (Arabic-first); numbers/prices always use Latin
/// digits via `NumberFormat('en')` (owner decision, docs/PLAN.md §10).
class LocaleController extends Notifier<Locale> {
  static const supported = ['ar', 'en'];

  @override
  Locale build() {
    final code = ref.watch(sharedPreferencesProvider).getString('locale');
    return Locale(supported.contains(code) ? code! : 'ar');
  }

  Future<void> setLocale(String code) async {
    if (!supported.contains(code)) return;
    await ref.read(sharedPreferencesProvider).setString('locale', code);
    state = Locale(code);
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);

final isRtlProvider = Provider<bool>(
  (ref) => ref.watch(localeControllerProvider).languageCode == 'ar',
);
