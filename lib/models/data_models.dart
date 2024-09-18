import 'package:uuid/uuid.dart';

class WorkoutCategory {
  String id;
  String name;

  WorkoutCategory({required this.name}) : id = const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory WorkoutCategory.fromMap(Map<String, dynamic> map) {
    return WorkoutCategory(name: map['name'])..id = map['id'];
  }
}

class Exercise {
  String id;
  String categoryId;
  String name;
  double weight;
  int reps;
  int sets;

  Exercise({
    required this.categoryId,
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'weight': weight,
      'reps': reps,
      'sets': sets,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      categoryId: map['categoryId'],
      name: map['name'],
      weight: map['weight'],
      reps: map['reps'],
      sets: map['sets'],
    )..id = map['id'];
  }
}
