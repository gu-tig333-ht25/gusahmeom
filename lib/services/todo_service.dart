import '../models/todo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for communicating with the Todo API.
class TodoService {
  static const _base = 'https://todoapp-api.apps.k8s.gu.se';
  static String? _key;
  static const _keyPref = 'todo_api_key';

  // Initialize: loads stored API key or registers a new one.
  static Future<void> init() async {
    if (_key != null) return;

    final prefs = await SharedPreferences.getInstance();
    _key = prefs.getString(_keyPref);

    if (_key == null) {
      final r = await http.get(Uri.parse('$_base/register'));
      if (r.statusCode != 200) {
        throw Exception('GET /register did not succeed');
      }
      _key = r.body.trim();
      await prefs.setString(_keyPref, _key!);
    }
  }

  // Query parameter for API key
  static String get _q => '?key=$_key';

  // Default headers for JSON requests.
  static Map<String, String> get _json => {'Content-Type': 'application/json'};

  // GET /todos — get all todos
  static Future<List<Todo>> getAll() async {
    final r = await http.get(Uri.parse('$_base/todos$_q'));
    if (r.statusCode != 200) throw Exception('GET /todos did not succeed');
    final list = (json.decode(r.body) as List).cast<Map<String, dynamic>>();
    return list.map(Todo.fromJson).toList();
  }

  // POST /todos — create a new todo
  static Future<List<Todo>> add(String title) async {
    final r = await http.post(
      Uri.parse('$_base/todos$_q'),
      headers: _json,
      body: json.encode({'title': title, 'done': false}),
    );
    if (r.statusCode != 200) throw Exception('POST /todos did not succeed');
    final list = (json.decode(r.body) as List).cast<Map<String, dynamic>>();
    return list.map(Todo.fromJson).toList();
  }

  // PUT /todos/:id — update a todo
  static Future<void> update(Todo t) async {
    final r = await http.put(
      Uri.parse('$_base/todos/${t.id}$_q'),
      headers: _json,
      body: json.encode(t.toJson()),
    );
    if (r.statusCode != 200) throw Exception('PUT /todos/{id} did not succeed');
  }

  // DELETE /todos/:id — remove a todo
  static Future<void> remove(Todo t) async {
    final r = await http.delete(Uri.parse('$_base/todos/${t.id}$_q'));
    if (r.statusCode != 200)
      throw Exception('DELETE /todos/{id} did not succeed');
  }

  // Returns a list of all undone todos
  static Future<List<Todo>> getAllUndone() async {
    final all = await getAll();
    return all.where((t) => !t.done).toList();
  }

  // Returns a list of all done todos
  static Future<List<Todo>> getAllDone() async {
    final all = await getAll();
    return all.where((t) => t.done).toList();
  }
}
