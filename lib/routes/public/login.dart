part of "public.dart";

// Handler che permette all'utente di eseguire il login e ricevere il JWT
// per accedere alle routes protette.
Future<Response> login(Request req) async {
  final payload = await req.readAsString();
  final data = jsonDecode(payload);

  // Accediamo a username e password tramite il payload della richiesta.
  final String username = data["username"];
  final String password = data["password"];

  // Cerchiamo un utente con lo stesso username nella lista [users].
  // Se assente, user diventa null
  final user = users.firstWhereOrNull((user) => user.username == username);

  // Se non abbiamo trovato nessun utente con il dato username, o se le password codificate
  // non corrispondono, rifiutiamo la richiesta.
  if (user == null || user.passwordHash != User.hashPassword(password)) {
    return Response.forbidden("Invalid username or password");
  }

  // Se il login va a buon fine, creiamo il JWT contenente un JSON con 
  // id e username. Questo verrà usato dall'utente per accedere alle routes protette.
  final jwt = JWT(
    {"id": user.id, "username": user.username},
  );

  // Infine "attiviamo" il JWT usando la chiave segreta salvata nelle variabili di ambiente.
  final token = jwt.sign(
    SecretKey(AppConfig.secretKey),
    // Possiamo specificare una data di scadenza, ad esempio ad un'ora dalla creazione.
    // Dopo un'ora, il JWT non sarà più valido.
    expiresIn: Duration(hours: 1),
  );

  // Infine inviamo il token come risposta.
  return Response.ok(
    jsonEncode({"token": token}),
    headers: {"Content-Type": "application/json"},
  );
}