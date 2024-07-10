part of "protected.dart";

// Handler per settare il campo "completed" di un todo a `true`.
Future<Response> completeTodo(Request req) async {
  // Accediamo all'id nel JWT.
  final String userId = (await RequestUtils.getDataFromJWT(req))["id"];

  // Accediamo al titolo del todo provveduto dall'utente tramite
  // il parametro nella richiesta.
  final todoTitle = req.params["title"];

  // Controlliamo se effettivamente è stato provveduto.
  if (todoTitle == null || todoTitle.isEmpty) {
    return Response.badRequest(body: "Title of todo missing or empty");
  }

  // Cerchiamo il todo.
  final todo = TodoManager.getTodoByTitle(todoTitle, userId);

  // Se il todo non esiste o l'utente non vi ha accesso, rifiutiamo
  // la richiesta.
  if (todo == null) {
    return Response.badRequest(body: "Unable to access to todo with title: $todoTitle");
  }

  // Creiamo un todo con `completed = true` e lo sostituiamo
  // a quello vecchio
  final newTodo = TodoManager.completeTodo(todo);

  // Ritorniamo il nuovo todo.
  return Response.ok(
    jsonEncode(newTodo.toJson()),
    headers: {"Content-Type": "application/json"},
  );
}
