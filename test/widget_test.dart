import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_project/main.dart';

void main() {
  testWidgets('Home page UI test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Check if AppBar title is displayed
    expect(find.text('E-Education'), findsOneWidget);

    // Check if Categories section exists
    expect(find.text('Categories'), findsOneWidget);

    // Check if Featured Courses section exists
    expect(find.text('Featured Courses'), findsOneWidget);

    // Check if at least one course is displayed
    expect(find.text('Flutter for Beginners'), findsOneWidget);
  });
}
