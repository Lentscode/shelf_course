import "dart:convert";
import "dart:io";

import "package:http/http.dart";
import "package:test/test.dart";

void main() {
  final port = "8080";
  final host = "http://0.0.0.0:$port";
  late Process p;

  setUp(() async {
    p = await Process.start(
      "dart",
      ["run", "bin/server.dart"],
      environment: {"PORT": port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  group("Authentication", () {
    test("Register success", () async {
      final registerRes = await post(
        Uri.parse("$host/api/register"),
        body: jsonEncode({"username": "lents", "password": "password"}),
      );
      final registerBody = jsonDecode(registerRes.body);

      expect(registerRes.statusCode, 200);
      expect(registerBody["username"], "lents");
      expect(registerBody["id"], isA<String>());

      final loginRes = await post(
        Uri.parse("$host/api/login"),
        body: jsonEncode({
          "username": "lents",
          "password": "password",
        }),
      );
      final loginBody = jsonDecode(registerRes.body);
      print(loginRes.statusCode);
      print(loginBody);

      expect(loginRes.statusCode, 200);
      expect(loginBody["token"], isA<String>());
    });
  });
}
