part of "protected.dart";

Future<Response> completeTodo(Request req) async {
  final jwt = req.context["jwt"] as JWT;
  final userId = jwt.payload["id"] as String;

  final payload = await req.readAsString();
  final data = jsonDecode(payload);

  final todoTitle = data["todoTitle"] as String?;

  if (todoTitle == null || todoTitle.isEmpty) {
    return Response.badRequest(body: "Title of todo missing or empty");
  }

  final todo = todos.firstWhereOrNull((todo) => todo.title == todoTitle);

  if (todo == null || todo.id != userId) {
    return Response.badRequest(body: "Unable to access to todo with title: $todoTitle");
  }

  final todoIndex = todos.indexOf(todo);
  final newTodo = todo.copyWith(completed: true);
  todos.insert(todoIndex, newTodo);

  return Response.ok(
    jsonEncode(newTodo),
    headers: {"Content-Type": "application/json"},
  );
}
