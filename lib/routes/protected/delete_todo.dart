part of "protected.dart";

// Handler per cancellare un todo.
Future<Response> deleteTodo(Request req) async {
  // Accediamo all'id dell'utente tramite il JWT
  final jwt = req.context["jwt"] as JWT;
  final userId = jwt.payload["id"] as String;

  // Accediamo al titolo del todo tramite il parametro della richiesta.s
  final todoTitle = req.params["title"];

  // Controlliamo se il titolo è stato dato.
  if (todoTitle == null || todoTitle.isEmpty) {
    return Response.badRequest(body: "Title is missing or empty");
  }

  // Cerchiamo il todo col titolo dato e controlliamo anche se è dell'utente.
  final todo = todos.firstWhereOrNull((todo) => todo.title == todoTitle && todo.userId == userId);

  // Se non esiste, rifiutiamo la richiesta.
  if (todo == null) {
    return Response.forbidden("Todo not existing or user have no access");
  }

  // Rimuoviamo il todo dalla lista.
  todos.remove(todo);

  // Ritorniamo un messaggio di conferma.
  return Response.ok(
    "Todo rimosso con successo",
    headers: {"Content-Type": "application/json"},
  );
}
