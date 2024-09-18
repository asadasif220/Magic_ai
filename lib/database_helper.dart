import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'data_models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Make this method public
  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB('workouts.db');
    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout_categories(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE exercises(
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        name TEXT NOT NULL,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        sets INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES workout_categories (id) ON DELETE CASCADE
      )
    ''');
  }

  // CRUD operations for WorkoutCategory
  Future<String> insertCategory(WorkoutCategory category) async {
    final db = await instance.database;
    await db.insert('workout_categories', category.toMap());
    return category.id;
  }

  Future<List<WorkoutCategory>> getCategories() async {
    final db = await instance.database;
    final categoriesData = await db.query('workout_categories');
    return categoriesData.map((data) => WorkoutCategory.fromMap(data)).toList();
  }

  Future<void> updateCategory(WorkoutCategory category) async {
    final db = await database;
    await db.update(
      'workout_categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(String id) async {
    final db = await database;
    await db.delete(
      'workout_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD operations for Exercise
  Future<String> insertExercise(Exercise exercise) async {
    final db = await instance.database;
    await db.insert('exercises', exercise.toMap());
    return exercise.id;
  }

  Future<List<Exercise>> getExercisesByCategory(String categoryId) async {
    final db = await instance.database;
    final exercisesData = await db.query(
      'exercises',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    return exercisesData.map((data) => Exercise.fromMap(data)).toList();
  }

  Future<void> updateExercise(Exercise exercise) async {
    final db = await database;
    await db.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<void> deleteExercise(String id) async {
    final db = await database;
    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
