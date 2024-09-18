import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_app/models/data_models.dart';
import 'package:magic_ai_app/helpers/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper dbHelper;
  late Database db;

  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Set the databaseFactory to use the FFI version
    databaseFactory = databaseFactoryFfi;
    // Create a new instance of DatabaseHelper
    dbHelper = DatabaseHelper.instance;
    // Initialize the database
    db = await dbHelper.initDB('test.db');
  });

  tearDownAll(() async {
    // Close the database after all tests are done
    await db.close();
  });

  setUp(() async {
    // Clear the database before each test
    await db.delete('workout_categories');
    await db.delete('exercises');
  });

  group('WorkoutCategory Tests', () {
    test('Create and Retrieve WorkoutCategory', () async {
      final category = WorkoutCategory(name: 'Test Category');
      await dbHelper.insertCategory(category);

      final categories = await dbHelper.getCategories();
      expect(categories.length, 1);
      expect(categories.first.name, 'Test Category');
    });

    test('Update WorkoutCategory', () async {
      final category = WorkoutCategory(name: 'Old Name');
      await dbHelper.insertCategory(category);

      category.name = 'New Name';
      await dbHelper.updateCategory(category);

      final categories = await dbHelper.getCategories();
      expect(categories.first.name, 'New Name');
    });

    test('Delete WorkoutCategory', () async {
      final category = WorkoutCategory(name: 'To Delete');
      await dbHelper.insertCategory(category);

      await dbHelper.deleteCategory(category.id);

      final categories = await dbHelper.getCategories();
      expect(categories.isEmpty, true);
    });
  });

  group('Exercise Tests', () {
    late WorkoutCategory testCategory;

    setUp(() async {
      testCategory = WorkoutCategory(name: 'Test Category');
      await dbHelper.insertCategory(testCategory);
    });

    test('Create and Retrieve Exercise', () async {
      final exercise = Exercise(
        categoryId: testCategory.id,
        name: 'Push-ups',
        weight: 0,
        reps: 10,
        sets: 3,
      );
      await dbHelper.insertExercise(exercise);

      final exercises = await dbHelper.getExercisesByCategory(testCategory.id);
      expect(exercises.length, 1);
      expect(exercises.first.name, 'Push-ups');
    });

    test('Update Exercise', () async {
      final exercise = Exercise(
        categoryId: testCategory.id,
        name: 'Old Exercise',
        weight: 10,
        reps: 10,
        sets: 3,
      );
      await dbHelper.insertExercise(exercise);

      exercise.name = 'New Exercise';
      exercise.weight = 15;
      await dbHelper.updateExercise(exercise);

      final exercises = await dbHelper.getExercisesByCategory(testCategory.id);
      expect(exercises.first.name, 'New Exercise');
      expect(exercises.first.weight, 15);
    });

    test('Delete Exercise', () async {
      final exercise = Exercise(
        categoryId: testCategory.id,
        name: 'To Delete',
        weight: 10,
        reps: 10,
        sets: 3,
      );
      await dbHelper.insertExercise(exercise);

      await dbHelper.deleteExercise(exercise.id);

      final exercises = await dbHelper.getExercisesByCategory(testCategory.id);
      expect(exercises.isEmpty, true);
    });
  });
}
