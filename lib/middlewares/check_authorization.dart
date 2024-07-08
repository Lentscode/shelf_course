import "package:dart_jsonwebtoken/dart_jsonwebtoken.dart";
import "package:shelf/shelf.dart";
import "../config/app_config.dart";

// Questo middleware viene chiamato ad ogni richiesta fatta nelle routes protette.
// Controlla che il JWT dato dall'utente sia valido per farlo accedere alla gestione
// dei todos.
Middleware checkAuthorization() {
  return (Handler innerHandler) {
    return (Request req) async {
      // Controlliamo che sia presente l'header di autorizzazione.
      // Se è nullo o non comincia con "Bearer ", rifiutiamo la richiesta
      final authHeader = req.headers["Authorization"];
      if (authHeader == null || !authHeader.startsWith("Bearer ")) {
        return Response.unauthorized("Missing or invalid authorization header");
      }

      // Recuperiamo il token JWT.
      final token = authHeader.substring(7);

      // Proviamo a verificare il JWT, riutilizzando la nostra chiave segreta.
      // Se il token è valido, lo aggiungiamo al contesto della richiesta, e 
      // aggiorniamo l'[innerHandler] con il nuovo contesto.
      //
      // Se il token non è valido, viene lanciata un'eccezione, che 
      // intercettiamo, rifiutando la richiesta.
      try {
        final jwt = JWT.verify(token, SecretKey(AppConfig.secretKey));
        final updateRequest = req.change(context: {"jwt": jwt});
        return await innerHandler(updateRequest);
      } catch (e) {
        return Response.unauthorized("Invalid token");
      }
    };
  };
}