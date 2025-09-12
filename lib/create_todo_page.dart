import 'package:flutter/material.dart';
import 'todo_store.dart';

// This widget provides a page to create a new todo item.

class CreateTodoPage extends StatelessWidget {
  CreateTodoPage({super.key});

  // Controller for the text input field
  final TextEditingController _controller = TextEditingController();

  // _onAddPressed adds the new todo and clears the input field.
  void _onAddPressed() {
    final text = _controller.text;
    if (text.isEmpty) {
      return;
    }

    TodoStore.add(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title and back button
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TIG333 TODO', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Body with text input and add button
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'What are you going to do?',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              onSubmitted: (_) => _onAddPressed(),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _onAddPressed, child: const Text('+ ADD')),
          ],
        ),
      ),
    );
  }
}
