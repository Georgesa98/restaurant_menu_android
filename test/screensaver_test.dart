import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/core/i18n/locale_controller.dart';
import 'package:restaurant_menu_android/features/kiosk/screensaver_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

void main() {
  test('starts hidden and enabled by default', () async {
    final c = await _container();
    addTearDown(c.dispose);
    expect(c.read(screensaverProvider), isFalse);
    expect(c.read(screensaverProvider.notifier).enabled, isTrue);
  });

  test('poke dismisses a showing overlay', () async {
    final c = await _container();
    addTearDown(c.dispose);
    c.read(screensaverProvider.notifier).fireForTest();
    expect(c.read(screensaverProvider), isTrue);
    c.read(screensaverProvider.notifier).poke();
    expect(c.read(screensaverProvider), isFalse);
  });

  test('disable persists and suppresses showing', () async {
    final c = await _container();
    addTearDown(c.dispose);
    await c.read(screensaverProvider.notifier).setEnabled(false);
    expect(c.read(screensaverProvider.notifier).enabled, isFalse);
    expect(
      (await SharedPreferences.getInstance())
          .getBool(Screensaver.prefKey),
      isFalse,
    );
  });
}
