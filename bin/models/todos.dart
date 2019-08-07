import 'todo.dart';

class Todos {
  Todos({this.lastId, this.todos});

  int lastId;
  List<Todo> todos;

  Todos.fromJson(Map<String, dynamic> json)
      : lastId = json['lastId'],
        todos = List<Todo>.from(json['todos'].map((todo) => Todo.fromJson(todo)));

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> todos = <Map<String, dynamic>>[];
    this.todos.forEach((todo) => todos.add(todo.toJson()));
    return {
      'lastId': lastId,
      'todos': todos,
    };
  }
}
