import 'package:flutter/material.dart';
import 'package:magic_ai_app/helpers/database_helper.dart';
import 'screens/category_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CategoryListScreen(
        dbHelper: dbHelper,
      ),
    );
  }
}
