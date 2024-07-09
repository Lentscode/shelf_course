part of "utils.dart";

class RequestUtils {
  // Funzione per accedere al corpo della richiesta
  static Future<Map<String, dynamic>> getPayload(Request req) async {
    final payload = await req.readAsString();
    final data = jsonDecode(payload);
    return data;
  }

  // Funzione per accedere ai dati contenuti dal JWT.
  static Future<Map<String, dynamic>> getDataFromJWT(Request req) async {
    final jwt = req.context["jwt"] as JWT;
    return jwt.payload;
  }
}
