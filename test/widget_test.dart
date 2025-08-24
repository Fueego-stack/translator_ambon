import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_translator/main.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our app starts successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}