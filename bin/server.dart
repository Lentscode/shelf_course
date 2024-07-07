import "dart:io";

import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart";
import "package:shelf_router/shelf_router.dart";

// Il router ci permette di definire delle routes per la nostra API, 
// con il la keyword corrispondente. In questo caso abbiamo due routes,
// entrambe sono dei GET. 
//
// Ogni route accetta il percorso da inserire nell'url per accederle e la
// funzione handler che si occupa di dare una risposta.
final _router = Router()
  ..get("/", _rootHandler)
  // Qui con le virgolette indichiamo che accettiamo un parametro,
  // da utilizzare poi nella funzione handler tramite la proprietà della
  // [Request] "params".
  ..get("/echo/<message>", _echoHandler);

// Semplice handler che ritorna un messaggio "Hello, World!".
Response _rootHandler(Request req) {
  return Response.ok("Hello, World!\n");
}

// Questo handler ritorna il messaggio passato come parametro.
Response _echoHandler(Request request) {
  final message = request.params["message"];
  return Response.ok("$message\n");
}

// Nel main facciamo partire il server.
void main(List<String> args) async {
  // Usa un qualsiasi host o container IP (di solito `0.0.0.0`)
  final ip = InternetAddress.anyIPv4;

  // Una [Pipeline] permette di aggiungere un [Middleware] a un handler - in questo caso
  // abbiamo direttamente il router. In questo modo, ad ogni richiesta, viene eseguito prima il middleware, 
  // che nel particolare stampa nel terminale la richiesta.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // Di solito, quando si fa partire il codice nei server, la porta da utilizzare
  // si trova nella variabile di ambiente "PORT". Se questa non è presente utilizziamo
  // "8080".
  final port = int.parse(Platform.environment["PORT"] ?? "8080");
  // Con serve() finalmente facciamo partire il server.
  final server = await serve(handler, ip, port);
  print("Server listening on port ${server.port}");
}
