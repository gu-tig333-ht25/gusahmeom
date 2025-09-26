// Model class for a Todo item.
class Todo {
  final String id;     
  final String title;
  final bool done;

  Todo({required this.id, required this.title, this.done = false});

  // JSON -> Todo (from API)
  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(id: json['id'], title: json['title'], done: json['done'] as bool);

  // Todo -> JSON (to API) 
  Map<String, dynamic> toJson() => {'title': title, 'done': done};

  // Create a copy of the Todo with modified fields
  Todo copyWith({String? title, bool? done}) =>
      Todo(id: id, title: title ?? this.title, done: done ?? this.done);
}
