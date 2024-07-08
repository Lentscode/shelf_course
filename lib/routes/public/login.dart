part of "public.dart";

Future<Response> login(Request req) async {
  final payload = await req.readAsString();
  final data = jsonDecode(payload);

  final String username = data["username"];
  final String password = data["password"];

  final user = users.firstWhereOrNull((user) => user.username == username);

  if (user == null || user.passwordHash != User.hashPassword(password)) {
    return Response.forbidden("Invalid username or password");
  }

  final jwt = JWT(
    {"id": user.id, "username": user.username},
  );

  final token = jwt.sign(
    SecretKey(AppConfig.secretKey),
    expiresIn: Duration(hours: 1),
  );

  return Response.ok(
    jsonEncode({"token": token}),
    headers: {"Content-Type": "application/json"},
  );
}