part of "public.dart";

// Handler utilizzato per registrare l'utente.
Future<Response> register(Request req) async {
  final payload = await req.readAsString();
  final data = jsonDecode(payload);

  // Dal payload della richiesta otteniamo username e password.
  final String username = data["username"];
  final String password = data["password"];

  // Se username o password sono vuoti rifiutiamo la richiesta.
  if (username.isEmpty || password.isEmpty) {
    return Response.badRequest(body: "Username and password are required");
  }

  // Controlliamo se l'username è stato già preso.
  // Se sì, rifiutiamo la richiesta.
  final userExisting = users.any((user) => user.username == username);
  if (userExisting) {
    return Response.forbidden("Error creating user. Retry");
  }

  // Codifichiamo la password usando SHA-256.
  final hashedPassword = User.hashPassword(password);

  // Creiamo un oggetto [User] con id uguale alla data attuale trasformata
  // in millisecondi e username e password codificata.
  final User user = User(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    username: username,
    passwordHash: hashedPassword,
  );

  // Aggiungiamo questo utente alla lista
  users.add(user);

  // Ritorniamo come risposta i dati dell'utente tramite il metodo 
  // toJson()
  return Response.ok(
    jsonEncode(user.toJson()),
    headers: {"Content-Type": "application/json"},
  );
}
