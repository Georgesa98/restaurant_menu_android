import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/features/admin/auth/admin_auth.dart';
import 'package:restaurant_menu_android/features/admin/widgets/admin_shell.dart';

void main() {
  test('unlock starts locked, unlocks, locks', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(adminUnlockedProvider), isFalse);
    c.read(adminUnlockedProvider.notifier).unlock();
    expect(c.read(adminUnlockedProvider), isTrue);
    c.read(adminUnlockedProvider.notifier).lock();
    expect(c.read(adminUnlockedProvider), isFalse);
  });

  testWidgets('idle timeout locks the UI', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(adminUnlockedProvider.notifier).unlock();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AdminShell(
            idleTimeout: Duration(milliseconds: 50),
            child: Text('admin'),
          ),
        ),
      ),
    );
    expect(container.read(adminUnlockedProvider), isTrue);

    await tester.pump(const Duration(milliseconds: 100));
    expect(container.read(adminUnlockedProvider), isFalse);
  });

  testWidgets('interaction re-arms the timer', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(adminUnlockedProvider.notifier).unlock();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AdminShell(
            idleTimeout: Duration(milliseconds: 200),
            child: Text('admin'),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    // Tap re-arms before the 200ms deadline.
    await tester.tap(find.text('admin'));
    await tester.pump(const Duration(milliseconds: 150));
    expect(container.read(adminUnlockedProvider), isTrue);
    await tester.pump(const Duration(milliseconds: 100));
    expect(container.read(adminUnlockedProvider), isFalse);
  });
}
