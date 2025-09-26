import 'package:flutter/material.dart';
import 'pages/todo_list_page.dart';


void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        surface: Colors.white,   
        onSurface: Colors.black, 
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black, 
      ),
    ),

      home: TodoListPage(),
    );
  }
}
