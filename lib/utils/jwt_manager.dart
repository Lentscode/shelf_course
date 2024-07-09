part of "utils.dart";

class JWTManager {
  // Funzione per creare un JWT contenente un JSON con
  // id e username. Questo verrà usato dall'utente per accedere alle routes protette.
  static String getToken(User user) {
    // Viene creato il JWT.
    final jwt = JWT(
      {"id": user.id, "username": user.username},
    );

    // "Attiviamo" il JWT usando la chiave segreta salvata nelle variabili di ambiente.
    final token = jwt.sign(
      SecretKey(AppConfig.secretKey),
      // Possiamo specificare una data di scadenza, ad esempio ad un'ora dalla creazione.
      // Dopo un'ora, il JWT non sarà più valido.
      expiresIn: Duration(hours: 1),
    );

    return token;
  }
}
