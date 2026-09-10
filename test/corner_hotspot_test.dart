import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_menu_android/features/menu/widgets/corner_hotspot.dart';

void main() {
  testWidgets('fires after a 2s hold', (tester) async {
    var fired = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CornerHotspot(onTrigger: () => fired++),
        ),
      ),
    );

    final center = tester.getCenter(find.byType(CornerHotspot));
    final gesture = await tester.startGesture(center);
    await tester.pump(const Duration(seconds: 1));
    expect(fired, 0);
    await tester.pump(const Duration(seconds: 2));
    expect(fired, 1);
    await gesture.up();
  });

  testWidgets('early lift cancels', (tester) async {
    var fired = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CornerHotspot(onTrigger: () => fired++),
        ),
      ),
    );

    final center = tester.getCenter(find.byType(CornerHotspot));
    final gesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pump(const Duration(seconds: 3));
    expect(fired, 0);
  });

  testWidgets('custom hold duration is honored', (tester) async {
    var fired = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CornerHotspot(
            hold: Duration(milliseconds: 100),
            onTrigger: () => fired++,
          ),
        ),
      ),
    );

    final center = tester.getCenter(find.byType(CornerHotspot));
    final gesture = await tester.startGesture(center);
    await tester.pump(const Duration(milliseconds: 150));
    expect(fired, 1);
    await gesture.up();
  });
}
