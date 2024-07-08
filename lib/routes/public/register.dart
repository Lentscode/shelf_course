part of "public.dart";

Future<Response> register(Request req) async {
  final payload = await req.readAsString();
  final data = jsonDecode(payload);

  final String username = data["username"];
  final String password = data["password"];

  if (username.isEmpty || password.isEmpty) {
    return Response.badRequest(body: "Username and password are required");
  }

  final userExisting = users.any((user) => user.username == username);

  if (userExisting) {
    return Response.forbidden("Error creating user. Retry");
  }

  final hashedPassword = User.hashPassword(password);

  final User user = User(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    username: username,
    passwordHash: hashedPassword,
  );

  users.add(user);

  return Response.ok(
    jsonEncode(user.toJson()),
    headers: {"Content-Type": "application/json"},
  );
}
