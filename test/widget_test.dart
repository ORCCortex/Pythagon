import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pythagon/main.dart';
import 'package:pythagon/services/problem_service.dart';

void main() {
  group('Pythagon App Tests', () {
    testWidgets('App starts and displays home screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const PythagonApp());

      // Verify that the app starts with the home screen
      expect(find.text('Pythagon'), findsOneWidget);
      expect(find.text('Math Homework Solver'), findsOneWidget);
      
      // Check for empty state when no problems exist
      expect(find.text('No problems yet'), findsOneWidget);
      
      // Verify floating action buttons are present
      expect(find.byType(FloatingActionButton), findsNWidgets(2));
    });

    testWidgets('Navigation buttons are present', (WidgetTester tester) async {
      await tester.pumpWidget(const PythagonApp());

      // Check for camera and gallery buttons
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byIcon(Icons.photo_library), findsOneWidget);
    });
  });

  group('Problem Service Tests', () {
    test('ProblemService initializes with empty list', () {
      final service = ProblemService();
      expect(service.problems, isEmpty);
    });

    test('getProblemById returns null for non-existent ID', () {
      final service = ProblemService();
      expect(service.getProblemById('non-existent'), isNull);
    });
  });
}