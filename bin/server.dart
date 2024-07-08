import "dart:io";

import "package:dotenv/dotenv.dart" show DotEnv;
import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart";
import "package:shelf_course/config/app_config.dart";
import "package:shelf_course/routes/public/public.dart";
import "package:shelf_router/shelf_router.dart";

// Configuriamo il router per le rotte pubbliche, ovvero accessibili anche
// agli utenti non autenticati, in quanto devono registrarsi.
final _publicRouter = Router()
  ..post("/register", register)
  ..get("/login", login);

// Creiamo una [Pipeline] con il router pubblico
final _publicHandler = const Pipeline().addHandler(_publicRouter.call);

// Montiamo la [Pipeline] pubblica all'indirizzo "/api/".
// In questo modo, appena creato il router privato, potremmo montarlo a un indirizzo diverso.
// Quindi possiamo avere più router su uno stesso server.
final mainRouter = Router()..mount("/api/", _publicHandler);

void main(List<String> args) async {
  // All'inizio del main, carichiamo le variabili d'ambiente che si trovano nel file
  // ".env". Accediamo a "SECRET_KEY" e la salviamo in [AppConfig], disponibile in
  // tutta l'app.
  final env = DotEnv(includePlatformEnvironment: true)..load();
  AppConfig.init(env["SECRET_KEY"]);

  // Usa un qualsiasi host o container IP (di solito `0.0.0.0`)
  final ip = InternetAddress.anyIPv4;

  // Creiamo una [Pipeline] con il router principale.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(mainRouter.call);

  // Di solito, quando si fa partire il codice nei server, la porta da utilizzare
  // si trova nella variabile di ambiente "PORT". Se questa non è presente utilizziamo
  // "8080".
  final port = int.parse(Platform.environment["PORT"] ?? "8080");
  // Con serve() finalmente facciamo partire il server.
  final server = await serve(handler, ip, port);
  print("Server listening on port ${server.port}");
}
