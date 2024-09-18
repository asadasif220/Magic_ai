import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_app/data_models.dart';
import 'package:magic_ai_app/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Set up sqflite_common_ffi for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('WorkoutCategory Model Tests', () {
    test('Create WorkoutCategory', () {
      final category = WorkoutCategory(name: 'Upper Body');
      expect(category.name, 'Upper Body');
      expect(category.id, isNotEmpty);
    });

    test('WorkoutCategory toMap and fromMap', () {
      final category = WorkoutCategory(name: 'Lower Body');
      final map = category.toMap();
      final deserializedCategory = WorkoutCategory.fromMap(map);
      expect(deserializedCategory.id, category.id);
      expect(deserializedCategory.name, category.name);
    });
  });

  group('Exercise Model Tests', () {
    test('Create Exercise', () {
      final exercise = Exercise(
        categoryId: 'cat1',
        name: 'Bench Press',
        weight: 50,
        reps: 10,
        sets: 3,
      );
      expect(exercise.name, 'Bench Press');
      expect(exercise.weight, 50);
      expect(exercise.reps, 10);
      expect(exercise.sets, 3);
      expect(exercise.id, isNotEmpty);
    });

    test('Exercise toMap and fromMap', () {
      final exercise = Exercise(
        categoryId: 'cat1',
        name: 'Squats',
        weight: 70,
        reps: 8,
        sets: 4,
      );
      final map = exercise.toMap();
      final deserializedExercise = Exercise.fromMap(map);
      expect(deserializedExercise.id, exercise.id);
      expect(deserializedExercise.categoryId, exercise.categoryId);
      expect(deserializedExercise.name, exercise.name);
      expect(deserializedExercise.weight, exercise.weight);
      expect(deserializedExercise.reps, exercise.reps);
      expect(deserializedExercise.sets, exercise.sets);
    });
  });

  group('DatabaseHelper Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      // Use an in-memory database for testing
      dbHelper = DatabaseHelper.instance;
      await dbHelper.initDB('test.db');
    });

    tearDown(() async {
      // Close the database after each test
      final db = await dbHelper.database;
      await db.close();
    });

    test('Insert and retrieve WorkoutCategory', () async {
      final category = WorkoutCategory(name: 'Test Category');
      await dbHelper.insertCategory(category);

      final categories = await dbHelper.getCategories();
      expect(categories.length, 1);
      expect(categories.first.name, 'Test Category');
    });

    test('Insert and retrieve Exercise', () async {
      final category = WorkoutCategory(name: 'Test Category');
      final categoryId = await dbHelper.insertCategory(category);

      final exercise = Exercise(
        categoryId: categoryId,
        name: 'Test Exercise',
        weight: 60,
        reps: 12,
        sets: 3,
      );
      await dbHelper.insertExercise(exercise);

      final exercises = await dbHelper.getExercisesByCategory(categoryId);
      expect(exercises.length, 1);
      expect(exercises.first.name, 'Test Exercise');
      expect(exercises.first.weight, 60);
      expect(exercises.first.reps, 12);
      expect(exercises.first.sets, 3);
    });
  });
}
