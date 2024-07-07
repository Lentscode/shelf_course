part of "protected.dart";

Future<Response> getTodos(Request req) async {
  final jwt = req.context["jwt"] as JWT;

  final String userId = jwt.payload["id"];

  final userTodos = todos.where((todo) => todo.id == userId).toList();

  return Response.ok(
    jsonEncode(userTodos.map((todo) => todo.toJson()).toList()),
    headers: {"Content-Type": "application/json"},
  );
}
