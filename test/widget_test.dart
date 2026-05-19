import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kido/config/app_locale_controller.dart'; // Make sure this path matches your project structure

import 'package:kido/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 1. Instantiate a mock or default instance of your controller
    final fakeLocaleController = AppLocaleController();

    // Note: If load() depends on SharedPreferences, you might need to supply 
    // default/initial values manually here if AppLocaleController allows it,
    // or use a mock. Assuming a fresh instance defaults safely for a smoke test:

    // 2. Pass the controller into MyApp
    await tester.pumpWidget(MyApp(localeController: fakeLocaleController));

    // Verify that our counter starts at 0.
    // Note: If your actual 'Logo' page doesn't have a counter, 
    // these assertions will still fail. Make sure 'find.text' matches your actual home screen UI!
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}