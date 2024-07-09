part of "utils.dart";

class UserManager {
  // Funzione per controllare se esiste un utente con un certo username.
  static bool checkIfUserExists(String username) => users.any((user) => user.username == username);

  // Funzione per creare un user nella lista "users".
  static User createUser(String username, String password) {
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

    return user;
  }

  // Funzione per eseguire il login di un utente.
  static User? tryLogin(String username, String password) {
    final user = users.firstWhereOrNull((user) => user.username == username);

    if (user != null && user.passwordHash == User.hashPassword(password)) {
      return user;
    }
    return null;
  }
}
