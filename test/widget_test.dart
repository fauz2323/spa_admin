// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spa_admin/main.dart';

void main() {
  testWidgets('SPA Admin app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpaAdminApp());

    // Verify that splash screen is loaded
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // The app should start with splash screen
    // This is a basic smoke test to ensure the app builds correctly
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
