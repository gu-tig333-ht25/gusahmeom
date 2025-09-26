import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'create_todo_page.dart';
import '../services/todo_service.dart';

// This widget represents the main page of the Todo application.

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  
  // Current filter: 'all', 'done', or 'undone'
  String filter = 'all';
  // Current list of todos
  List<Todo> _todos = [];

  // Initialize state and load todos
  @override
  void initState() {
    super.initState();
    _init();
  }

  // Initialize the TodoStore and load the initial list of todos
  Future<void> _init() async {
    await TodoService.init(); 
    await _reload(); 
  }

  // Reload the list of todos based on the current filter
  Future<void> _reload() async {
    List<Todo> list;
    if (filter == 'all') {
      list = await TodoService.getAll();
    } else if (filter == 'undone') {
      list = await TodoService.getAllUndone();
    } else {
      list = await TodoService.getAllDone();
    }
    if (mounted) setState(() => _todos = list);
  }

  // Get the current list of todos
  List<Todo> getTodos() => _todos;

  // Change filter and refresh list
  void _filterTodos(String selectedFilter) async {
    setState(() => filter = selectedFilter);
    await _reload();
  }

  // Toggle todo done status and refresh list
  Future<void> _onTodoToggle(int index) async {
    final t = getTodos()[index];
    final updated = t.copyWith(done: !t.done); 
    await TodoService.update(updated); 
    await _reload(); 
  }

  // Remove todo and refresh list
  Future<void> _onTodoRemove(int index) async {
    final t = getTodos()[index];
    await TodoService.remove(t); 
    await _reload();
  }

  // Navigate to CreateTodoPage and refresh list on return
  Future<void> _onCreateTodo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateTodoPage()),
    );

    await _reload(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title and filter menu
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TIG333 TODO'),
        // Menu for filtering todos
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => () {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: const Text('all'),
                onTap: () => _filterTodos('all'),
              ),
              PopupMenuItem(
                value: 2,
                child: const Text('done'),
                onTap: () => _filterTodos('done'),
              ),
              PopupMenuItem(
                value: 3,
                child: Text('undone'),
                onTap: () => _filterTodos('undone'),
              ),
            ],
          ),
        ],
      ),
      // Build scrollable list of todos
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            // Checkbox to toggle done status
            leading: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.5),
              ),
              child: Checkbox(
                value: todo.done,
                onChanged: (_) => _onTodoToggle(index),
                checkColor: Colors.black,
                fillColor: WidgetStateProperty.all(Colors.transparent),
                side: const BorderSide(color: Colors.transparent),
              ),
            ),

            // Title with strikethrough if done
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            // Button to remove todo
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _onTodoRemove(index),
            ),
          );
        },
      ),
      // Floating action button to create a new todo
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateTodo,
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(Icons.add, color: Colors.white, size: 50),
      ),
    );
  }
}
