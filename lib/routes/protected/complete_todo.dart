part of "protected.dart";

// Handler per settare il campo "completed" di un todo a `true`.
Future<Response> completeTodo(Request req) async {
  // Accediamo all'id nel JWT.
  final jwt = req.context["jwt"] as JWT;
  final userId = jwt.payload["id"] as String;

  // Accediamo al titolo del todo provveduto dall'utente tramite
  // il parametro nella richiesta.
  final todoTitle = req.params["title"];

  // Controlliamo se effettivamente è stato provveduto.
  if (todoTitle == null || todoTitle.isEmpty) {
    return Response.badRequest(body: "Title of todo missing or empty");
  }

  // Cerchiamo il todo.
  final todo = todos.firstWhereOrNull((todo) => todo.title == todoTitle);

  // Se il todo non esiste o l'utente non vi ha accesso, rifiutiamo
  // la richiesta.
  if (todo == null || todo.userId != userId) {
    return Response.badRequest(body: "Unable to access to todo with title: $todoTitle");
  }

  // Accediamo all'indice di questo todo per sostituirlo con uno nuovo
  // con `completed = true`.
  final todoIndex = todos.indexOf(todo);
  final newTodo = todo.copyWith(completed: true);
  todos.insert(todoIndex, newTodo);

  // Ritorniamo il nuovo todo.
  return Response.ok(
    jsonEncode(newTodo.toJson()),
    headers: {"Content-Type": "application/json"},
  );
}
