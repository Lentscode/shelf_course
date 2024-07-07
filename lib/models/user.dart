import "dart:convert";

import "package:crypto/crypto.dart";

class User {
  final String id;
  final String username;
  final String passwordHash;

  const User({required this.id, required this.username, required this.passwordHash});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        passwordHash: json["passwordHash"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };

  static String hashPassword(String password) => sha256.convert(utf8.encode(password)).toString();
}

List<User> users = [];
