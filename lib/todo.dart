// A simple Todo class with title and done status
class Todo {
  final String title;
  bool done;

  Todo({required this.title, this.done = false});

  void toggle() {
    done = !done;
  }
}
