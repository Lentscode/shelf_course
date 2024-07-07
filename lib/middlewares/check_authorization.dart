import "package:dart_jsonwebtoken/dart_jsonwebtoken.dart";
import "package:shelf/shelf.dart";
import "../config/app_config.dart";

Middleware checkAuthorization() {
  return (Handler innerHandler) {
    return (Request req) async {
      final authHeader = req.headers["Authorization"];

      if (authHeader == null || !authHeader.startsWith("Bearer ")) {
        return Response.unauthorized("Missing or invalid authorization header");
      }

      final token = authHeader.substring(7);

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
