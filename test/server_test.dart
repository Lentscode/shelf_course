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

  test("Root", () async {
    final response = await post(
      Uri.parse("$host/api/register"),
      body: {"username": "lents", "password": "password"},
    );
    expect(response.statusCode, 200);
    final body = jsonDecode(response.body);
    expect(body["username"], "lents");
    expect(body["password"], isA<String>());
  });
}
