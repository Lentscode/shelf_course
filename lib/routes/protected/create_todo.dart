part of "protected.dart";

Future<Response> createTodo(Request req) async {
  final jwt = req.context["jwt"] as JWT;
  final String userId = jwt.payload["id"];

  final payload = await req.readAsString();
  final data = jsonDecode(payload);

  if (data["title"] == null || (data["title"] as String).isEmpty) {
    return Response.badRequest(body: "Title missing or empty");
  }

  final Todo todo = Todo.fromJson(data).copyWith(userId: userId);

  todos.add(todo);

  return Response.ok(
    jsonEncode(todo),
    headers: {"Content-Type": "application/json"},
  );
}
