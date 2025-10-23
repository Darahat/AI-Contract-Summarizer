import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clausewise/main.dart';

void main() {
  testWidgets('ClauseWise app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ClauseWiseApp()));

    // Verify that splash screen is displayed
    expect(find.text('ClauseWise'), findsOneWidget);
    expect(find.text('Your AI Legal Companion'), findsOneWidget);
  });
}
