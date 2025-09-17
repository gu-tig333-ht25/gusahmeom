import 'package:flutter/material.dart';
import 'package:template/todo.dart';
import 'create_todo_page.dart';
import 'todo_store.dart';

// This widget is the main page of the app, displaying the list of todos.

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  String filter = 'all';

  // getTodos returns the list of todos based on the current filter.
  List<Todo> getTodos() {
    if (filter == 'all') {
      return TodoStore.todos;
    } else if (filter == 'done') {
      return TodoStore.getAlldone();
    } else if (filter == 'undone') {
      return TodoStore.getAllundone();
    } else {
      return TodoStore.todos;
    }
  }

  // _filterTodos updates the filter and refreshes the UI.
  void _filterTodos(String selectedFilter) {
    setState(() {
      filter = selectedFilter;
    });
  }

  // _onTodoToggle toggles the done status of a todo and refreshes the UI.
  void _onTodoToggle(int index) {
    setState(() {
      TodoStore.toggle(index);
    });
  }

  // _onTodoRemove removes a todo and refreshes the UI.
  void _onTodoRemove(int index) {
    setState(() {
      TodoStore.remove(index);
    });
  }

  // _onCreateTodo navigates to the CreateTodoPage and refreshes the UI when returning.
  void _onCreateTodo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTodoPage()),
    ).then((_) {
      setState(() {});
    });
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
        itemCount: getTodos().length,
        itemBuilder: (context, index) {
          final todo = getTodos()[index];
          return ListTile(
            // Checkbox to toggle done status
            leading: Checkbox(
              value: todo.done,
              onChanged: (_) => _onTodoToggle(index),
              fillColor: const WidgetStatePropertyAll(Colors.transparent),
              checkColor: Colors.black,
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
