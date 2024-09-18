import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_app/screens/category_list_screen.dart';
import 'package:magic_ai_app/models/data_models.dart';
import 'package:magic_ai_app/screens/exercise_list_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:magic_ai_app/helpers/database_helper.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([DatabaseHelper])
import 'widget_test.mocks.dart';

void main() {
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
  });

  testWidgets('CategoryListScreen shows categories and CRUD options',
      (WidgetTester tester) async {
    final categories = [
      WorkoutCategory(name: 'Category 1')..id = '1',
      WorkoutCategory(name: 'Category 2')..id = '2',
    ];

    when(mockDatabaseHelper.getCategories())
        .thenAnswer((_) async => categories);

    await tester.pumpWidget(MaterialApp(
        home: CategoryListScreen(
      dbHelper: mockDatabaseHelper,
    )));

    expect(find.text('Category 1'), findsOneWidget);
    expect(find.text('Category 2'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsNWidgets(2));
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
  });

  testWidgets('ExerciseListScreen shows exercises and CRUD options',
      (WidgetTester tester) async {
    final category = WorkoutCategory(name: 'Test Category')..id = '1';
    final exercises = [
      Exercise(
          categoryId: '1', name: 'Exercise 1', weight: 10, reps: 10, sets: 3)
        ..id = '1',
      Exercise(
          categoryId: '1', name: 'Exercise 2', weight: 20, reps: 8, sets: 4)
        ..id = '2',
    ];

    when(mockDatabaseHelper.getExercisesByCategory(category.id))
        .thenAnswer((_) async => exercises);

    await tester
        .pumpWidget(MaterialApp(home: ExerciseListScreen(category: category)));

    expect(find.text('Exercise 1'), findsOneWidget);
    expect(find.text('Exercise 2'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsNWidgets(2));
    expect(find.byIcon(Icons.delete), findsNWidgets(2));
  });
}
