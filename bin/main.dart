import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';

import 'db/db.dart';
import 'models/todo.dart';

main() async {
  var app = Angel(), http = AngelHttp(app);
  app
    ..get('/todos', _getTodos)
    ..get('/todo/:id', _getTodo)
    ..post('/todo', _postTodo)
    ..put('/todo/:id', _putTodo)
    ..delete('/todo/:id', _deleteTodo)
    ..fallback((req, res) => throw AngelHttpException.notFound());
  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}

void _getTodos(RequestContext req, ResponseContext res) {
  Db db = Db();
  List<Todo> todos = db.getTodos();
  res.serialize(todos);

  print('[${DateTime.now()}]: Get Todos is success');
}

void _getTodo(RequestContext req, ResponseContext res) {
  if (!req.params.containsKey('id')) {
    throw AngelHttpException.badRequest();
  }
  int id = int.tryParse(req.params['id']);
  if (id == null) {
    throw AngelHttpException.badRequest(message: 'param "id" must be a number');
  }

  Db db = Db();
  Todo todo = db.getTodo(id);

  if (todo == null) {
    print('[${DateTime.now()}]: Get Todo #$id is failed');

    throw AngelHttpException.notFound();
  }

  res.serialize(todo);

  print('[${DateTime.now()}]: Get Todo #$id is success');
}

Future _postTodo(RequestContext req, ResponseContext res) async {
  if (!req.hasParsedBody) {
    await req.parseBody();
  }

  Map<String, dynamic> bodyAsMap = req.bodyAsMap;
  bool isComplete = bodyAsMap['isComplete'] ?? false;
  String title = bodyAsMap['title'] ?? '';
  String text = bodyAsMap['text'] ?? '';

  Db db = Db();
  int id = db.createTodo(isComplete, title, text);
  res.serialize({ 'success': true });

  print('[${DateTime.now()}]: Create Todo #$id is success');
}

Future _putTodo(RequestContext req, ResponseContext res) async {
  if (!req.hasParsedBody) {
    await req.parseBody();
  }
  int id = int.tryParse(req.params['id']);
  if (id == null) {
    print('[${DateTime.now()}]: Update Todo #$id is failed');

    throw AngelHttpException.badRequest(message: 'param "id" must be a number');
  }

  Map<String, dynamic> bodyAsMap = req.bodyAsMap;

  Db db = Db();
  bool isUpdated = db.updateTodo(id, bodyAsMap);
  res.serialize({ 'success': isUpdated });

  print('[${DateTime.now()}]: Update Todo #$id is ${isUpdated ? 'success' : 'failed'}');
}

void _deleteTodo(RequestContext req, ResponseContext res) {
  int id = int.tryParse(req.params['id']);
  if (id == null) {
    print('[${DateTime.now()}]: Delete Todo #$id is failed');

    throw AngelHttpException.badRequest(message: 'param "id" must be a number');
  }

  Db db = Db();
  bool isDeleted = db.deleteTodo(id);
  res.serialize({ 'success': isDeleted });

  print('[${DateTime.now()}]: Delete Todo #$id is ${isDeleted ? 'success' : 'failed'}');
}