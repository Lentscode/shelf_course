part of "protected.dart";

Future<Response> deleteTodo(Request req) async {
  final jwt = req.context["jwt"] as JWT;
  final userId = jwt.payload["id"] as String;

  final payload = await req.readAsString();
  final data = jsonDecode(payload);

  final todoTitle = data["todoTitle"] as String?;

  if (todoTitle == null || todoTitle.isEmpty) {
    return Response.badRequest(body: "Title is missing or empty");
  }

  final todo = todos.firstWhereOrNull((todo) => todo.title == todoTitle && todo.id == userId);

  if (todo == null) {
    return Response.forbidden("Todo not existing or user have no access");
  }

  todos.remove(todo);

  return Response.ok(
    jsonEncode(todos),
    headers: {"Content-Type": "application/json"},
  );
}
