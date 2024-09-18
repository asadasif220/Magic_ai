import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:magic_ai_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Create, update, and delete category and exercise',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Create a new category
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test Category');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Test Category'), findsOneWidget);

      // Update the category
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Updated Category');
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(find.text('Updated Category'), findsOneWidget);

      // Navigate to ExerciseListScreen
      await tester.tap(find.text('Updated Category'));
      await tester.pumpAndSettle();

      // Create a new exercise
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'Exercise Name'), 'Test Exercise');
      await tester.enterText(
          find.widgetWithText(TextField, 'Weight (kg)'), '50');
      await tester.enterText(find.widgetWithText(TextField, 'Reps'), '10');
      await tester.enterText(find.widgetWithText(TextField, 'Sets'), '3');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Test Exercise'), findsOneWidget);
      expect(find.text('50kg, 10 reps, 3 sets'), findsOneWidget);

      // Update the exercise
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'Exercise Name'), 'Updated Exercise');
      await tester.enterText(
          find.widgetWithText(TextField, 'Weight (kg)'), '60');
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(find.text('Updated Exercise'), findsOneWidget);
      expect(find.text('60kg, 10 reps, 3 sets'), findsOneWidget);

      // Delete the exercise
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Updated Exercise'), findsNothing);

      // Navigate back to CategoryListScreen
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Delete the category
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Updated Category'), findsNothing);
    });
  });
}
