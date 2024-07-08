import "dart:convert";

import "package:crypto/crypto.dart";

// Classe che rappresenta un utente salvato all'interno del server.
class User {
  // Id dell'utente.
  final String id;
  // Username dell'utente.
  final String username;
  // Password codificata in modo da non esporla direttamente.
  final String passwordHash;

  const User({required this.id, required this.username, required this.passwordHash});

  // Usato per inviare i dati dell'utente al momento della registrazione.
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };

  // Metodo per codificare la password data.
  static String hashPassword(String password) => sha256.convert(utf8.encode(password)).toString();
}

// Lista degli utenti registrati al server.
List<User> users = [];
