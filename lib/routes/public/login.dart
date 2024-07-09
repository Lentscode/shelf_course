part of "public.dart";

// Handler che permette all'utente di eseguire il login e ricevere il JWT
// per accedere alle routes protette.
Future<Response> login(Request req) async {
  final data = await RequestUtils.getPayload(req);

  // Accediamo a username e password tramite il payload della richiesta.
  final String username = data["username"];
  final String password = data["password"];

  // Cerchiamo un utente con lo stesso username nella lista [users].
  // Se assente, user diventa null
  final user = UserManager.tryLogin(username, password);

  // Se non abbiamo trovato nessun utente con il dato username, o se le password codificate
  // non corrispondono, rifiutiamo la richiesta.
  if (user == null) {
    return Response.forbidden("Invalid username or password");
  }

  // Creiamo il token con cui l'utente può accedere.
  final token = JWTManager.getToken(user);

  // Infine inviamo il token come risposta.
  return Response.ok(
    jsonEncode({"token": token}),
    headers: {"Content-Type": "application/json"},
  );
}
