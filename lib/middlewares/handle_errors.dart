import "package:shelf/shelf.dart";

Middleware handleErrors() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (e, stack) {
        print("Errore: $e\n$stack");
        return Response.internalServerError(body: "Internal Server Error");
      }
    };
  };
}
