import 'todo.dart';

// A static store for managing the list of todos
class TodoStore {
  // A static list to hold all todos
  static final List<Todo> todos = [];

  // Adds a new todo to the list
  static void add(String title) {
    todos.add(Todo(title: title));
  }

  // Toggles the done status of a todo at the given index
  static void toggle(int index) {
    todos[index].toggle();
  }

  // Removes a todo at the given index
  static void remove(int index) {
    todos.removeAt(index);
  }

  // Returns a list of all undone todos
  static List<Todo> getAllundone() {
    return todos.where((todo) => !todo.done).toList();
  }

  // Returns a list of all done todos
  static List<Todo> getAlldone() {
    return todos.where((todo) => todo.done).toList();
  }
}
