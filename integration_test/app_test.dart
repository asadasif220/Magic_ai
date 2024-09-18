import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:magic_ai_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Add category, navigate to exercises, add exercise',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on the CategoryListScreen
      expect(find.text('Workout Tracker'), findsOneWidget);

      // Add a new category
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test Category');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify the new category is in the list
      expect(find.text('Test Category'), findsOneWidget);

      // Navigate to the ExerciseListScreen
      await tester.tap(find.text('Test Category'));
      await tester.pumpAndSettle();

      // Verify we're on the ExerciseListScreen
      expect(find.text('Test Category'), findsOneWidget);

      // Add a new exercise
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in exercise details
      await tester.enterText(
          find.widgetWithText(TextField, 'Exercise Name'), 'Test Exercise');
      await tester.enterText(
          find.widgetWithText(TextField, 'Weight (kg)'), '50');
      await tester.enterText(find.widgetWithText(TextField, 'Reps'), '10');
      await tester.enterText(find.widgetWithText(TextField, 'Sets'), '3');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify the new exercise is in the list
      expect(find.text('Test Exercise'), findsOneWidget);
      expect(find.text('50kg, 10 reps, 3 sets'), findsOneWidget);
    });
  });
}
