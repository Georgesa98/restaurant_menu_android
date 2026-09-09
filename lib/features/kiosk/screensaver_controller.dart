import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/locale_controller.dart';

/// Idle attract loop (docs/PLAN.md §15): after [idleTimeout] without PointerDown,
/// [showing] flips true and the app presents the overlay; any touch dismisses
/// and re-arms. Disabled via admin toggle.
class Screensaver extends Notifier<bool> {
  static const idleTimeout = Duration(minutes: 3);
  static const prefKey = 'screensaver_enabled';

  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    _armIfEnabled();
    return false;
  }

  bool get enabled =>
      ref.read(sharedPreferencesProvider).getBool(prefKey) ?? true;

  Future<void> setEnabled(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(prefKey, value);
    if (!value) {
      _timer?.cancel();
      state = false;
    } else {
      _armIfEnabled();
    }
  }

  void _armIfEnabled() {
    _timer?.cancel();
    if (enabled) {
      _timer = Timer(idleTimeout, () => state = true);
    }
  }

  /// Call on every pointer-down (and on overlay dismiss).
  void poke() {
    if (state) state = false;
    _armIfEnabled();
  }

  /// Test only: simulate the idle timer firing.
  void fireForTest() => state = true;
}

final screensaverProvider =
    NotifierProvider<Screensaver, bool>(Screensaver.new);
