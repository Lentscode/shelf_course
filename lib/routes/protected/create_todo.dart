part of "protected.dart";

// Handler per creare un todo. Abbiamo bisogno di accedere all'id all'interno
// del JWT per inserirlo nel nuovo todo.
Future<Response> createTodo(Request req) async {
  // Accediamo all'id nel JWT.
  final String userId = (await RequestUtils.getDataFromJWT(req))["id"];

  // Accediamo al corpo della richiesta.
  final data = await RequestUtils.getPayload(req);

  // Essendo solo il titolo obbligatorio, controlliamo se è stato inserito.
  if (data["title"] == null || (data["title"] as String).isEmpty) {
    return Response.badRequest(body: "Title missing or empty");
  }

  // Creiamo il nostro todo e lo aggiungiamo alla lista.
  final todo = TodoManager.createTodo(data, userId);

  // Ritorniamo come risposta lo stesso todo.
  return Response.ok(
    jsonEncode(todo.toJson()),
    headers: {"Content-Type": "application/json"},
  );
}
