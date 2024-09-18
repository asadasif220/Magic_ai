import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../helpers/database_helper.dart';

class ExerciseListScreen extends StatefulWidget {
  final WorkoutCategory category;

  const ExerciseListScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() async {
    final exercises = await DatabaseHelper.instance
        .getExercisesByCategory(widget.category.id);
    setState(() {
      _exercises = exercises;
    });
  }

  void _editExercise(Exercise exercise) async {
    final nameController = TextEditingController(text: exercise.name);
    final weightController =
        TextEditingController(text: exercise.weight.toString());
    final repsController =
        TextEditingController(text: exercise.reps.toString());
    final setsController =
        TextEditingController(text: exercise.sets.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Exercise Name'),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: setsController,
                decoration: const InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  weightController.text.isNotEmpty &&
                  repsController.text.isNotEmpty &&
                  setsController.text.isNotEmpty) {
                exercise.name = nameController.text;
                exercise.weight = double.parse(weightController.text);
                exercise.reps = int.parse(repsController.text);
                exercise.sets = int.parse(setsController.text);
                await DatabaseHelper.instance.updateExercise(exercise);
                Navigator.pop(context);
                _loadExercises();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteExercise(Exercise exercise) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Exercise'),
        content: Text('Are you sure you want to delete "${exercise.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteExercise(exercise.id);
      _loadExercises();
    }
  }

  void _addExercise() async {
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    final repsController = TextEditingController();
    final setsController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Exercise Name'),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: setsController,
                decoration: const InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  weightController.text.isNotEmpty &&
                  repsController.text.isNotEmpty &&
                  setsController.text.isNotEmpty) {
                final exercise = Exercise(
                  categoryId: widget.category.id,
                  name: nameController.text,
                  weight: double.parse(weightController.text),
                  reps: int.parse(repsController.text),
                  sets: int.parse(setsController.text),
                );
                await DatabaseHelper.instance.insertExercise(exercise);
                Navigator.pop(context);
                _loadExercises();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: Colors.blue,
      ),
      body: _exercises.isEmpty
          ? const Center(child: Text('No exercise added'))
          : ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(
                      '${exercise.weight}kg, ${exercise.reps} reps, ${exercise.sets} sets'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editExercise(exercise),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteExercise(exercise),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
