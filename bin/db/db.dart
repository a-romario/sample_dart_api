import 'dart:io';
import 'dart:convert' show jsonDecode, jsonEncode;

import '../models/todo.dart';
import '../models/todos.dart';

class Db {
  static Db _db;
  File _file;

  factory Db() {
    if (_db == null) {
      _db = Db._();
    }
    return _db;
  }

  Db._() {
    _file = File('data.txt');
  }

  Todos _readFromDb() {
    Todos todos;
    try {
      String model = _file.readAsStringSync();
      todos = Todos.fromJson(jsonDecode(model));
    } catch(e) {
      print('Error while json decode, $e');
      todos = new Todos(lastId: 0, todos: []);
    }
    return todos;
  }

  void _writeToDb(Todos todos) {
    try {
      var json = todos.toJson();
      String model = jsonEncode(json);
      if (!_file.existsSync()) {
        _file.createSync();
      }
      _file.writeAsStringSync(model);
    } catch (e) {
      print('Error while json encode, $e');
    }
  }

  List<Todo> getTodos() {
    Todos model = _readFromDb();
    return model.todos;
  }

  Todo getTodo(int id) {
    List<Todo> todos = getTodos();
    try {
      Todo result = todos.firstWhere((todo) => todo.id == id);
      return result;
    } catch (e) {
      return null;
    }
  }

  int createTodo(bool isComplete, String title, String text) {
    Todos model = _readFromDb();
    Todo newTodo = Todo(id: ++model.lastId, isComplete: isComplete, title: title, text: text);
    model.todos.add(newTodo);
    _writeToDb(model);
    return model.lastId;
  }

  bool updateTodo(int id, Map<String, dynamic> todoProps) {
    Todos model = _readFromDb();
    int todoIndex = model.todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) {
      return false;
    }
    bool isComplete = todoProps['isComplete'] ?? model.todos[todoIndex].isComplete;
    String title = todoProps['title'] ?? model.todos[todoIndex].title;
    String text = todoProps['text'] ?? model.todos[todoIndex].text;
    model.todos[todoIndex]
      ..isComplete = isComplete
      ..title = title
      ..text = text;
    _writeToDb(model);
    return true;
  }

  bool deleteTodo(int id) {
    Todos model = _readFromDb();
    int todoIndex = model.todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) {
      return false;
    }
    model.todos.removeAt(todoIndex);
    _writeToDb(model);
    return true;
  }
}