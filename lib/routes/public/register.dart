part of "public.dart";

// Handler utilizzato per registrare l'utente.
Future<Response> register(Request req) async {
  final data = await RequestUtils.getPayload(req);

  // Dal payload della richiesta otteniamo username e password.
  final String username = data["username"];
  final String password = data["password"];

  // Se username o password sono vuoti rifiutiamo la richiesta.
  if (username.isEmpty || password.isEmpty) {
    return Response.badRequest(body: "Username and password are required");
  }

  // Controlliamo se l'username è stato già preso.
  // Se sì, rifiutiamo la richiesta.
  final userExisting = UserManager.checkIfUserExists(username);
  if (userExisting) {
    return Response.forbidden("Error creating user. Retry");
  }

  final User user = UserManager.createUser(username, password);

  // Ritorniamo come risposta i dati dell'utente tramite il metodo
  // toJson()
  return Response.ok(
    jsonEncode(user.toJson()),
    headers: {"Content-Type": "application/json"},
  );
}
