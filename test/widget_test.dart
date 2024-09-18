import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_app/category_list_screen.dart';
import 'package:magic_ai_app/data_models.dart';
import 'package:magic_ai_app/exercise_list_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:magic_ai_app/database_helper.dart';
import 'package:mockito/mockito.dart';

// Generate mock classes
@GenerateMocks([DatabaseHelper])
import 'widget_test.mocks.dart';

void main() {
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
  });

  testWidgets('CategoryListScreen UI Test', (WidgetTester tester) async {
    // Mock the database helper to return a list of categories
    when(mockDatabaseHelper.getCategories()).thenAnswer((_) async => [
          WorkoutCategory(name: 'Upper Body')..id = '1',
          WorkoutCategory(name: 'Lower Body')..id = '2',
        ]);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: CategoryListScreen()));

    // Verify that the screen title is correct
    expect(find.text('Workout Tracker'), findsOneWidget);

    // Verify that the categories are displayed
    expect(find.text('Upper Body'), findsOneWidget);
    expect(find.text('Lower Body'), findsOneWidget);

    // Verify that the add button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('ExerciseListScreen UI Test', (WidgetTester tester) async {
    final category = WorkoutCategory(name: 'Test Category')..id = '1';

    // Mock the database helper to return a list of exercises
    when(mockDatabaseHelper.getExercisesByCategory(category.id))
        .thenAnswer((_) async => [
              Exercise(
                  categoryId: category.id,
                  name: 'Push-ups',
                  weight: 0,
                  reps: 20,
                  sets: 3)
                ..id = '1',
              Exercise(
                  categoryId: category.id,
                  name: 'Bench Press',
                  weight: 50,
                  reps: 10,
                  sets: 3)
                ..id = '2',
            ]);

    // Build our app and trigger a frame.
    await tester
        .pumpWidget(MaterialApp(home: ExerciseListScreen(category: category)));

    // Verify that the screen title is correct
    expect(find.text('Test Category'), findsOneWidget);

    // Verify that the exercises are displayed
    expect(find.text('Push-ups'), findsOneWidget);
    expect(find.text('Bench Press'), findsOneWidget);

    // Verify that the exercise details are displayed
    expect(find.text('0kg, 20 reps, 3 sets'), findsOneWidget);
    expect(find.text('50kg, 10 reps, 3 sets'), findsOneWidget);

    // Verify that the add button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
