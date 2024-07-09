part of "protected.dart";

// Handler per ritornare i todo dell'utente, ottenuti tramite il suo id.
Future<Response> getTodos(Request req) async {
  // Accediamo all'id dell'utente dal JWT.
  final String userId = (await RequestUtils.getDataFromJWT(req))["id"];

  // Cerchiamo i todo con il suo id.
  final userTodos = TodoManager.getTodosOfUser(userId);

  // Li ritorniamo nella risposta.
  return Response.ok(
    jsonEncode(userTodos.map((todo) => todo.toJson()).toList()),
    headers: {"Content-Type": "application/json"},
  );
}
