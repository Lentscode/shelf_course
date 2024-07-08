import "dart:io";

import "package:dotenv/dotenv.dart" show DotEnv;
import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart";
import "package:shelf_course/config/app_config.dart";
import "package:shelf_course/middlewares/check_authorization.dart";
import "package:shelf_course/middlewares/handle_errors.dart";
import "package:shelf_course/routes/protected/protected.dart";
import "package:shelf_course/routes/public/public.dart";
import "package:shelf_router/shelf_router.dart";

// Configure routes.
final _publicRouter = Router()
  ..get("/", root)
  ..post("/register", register)
  ..get("/login", login);
final _protectedRouter = Router()
  ..get("/todos", getTodos)
  ..post("/todos", createTodo)
  ..patch("/todos/<title>", completeTodo)
  ..delete("/todos/<title>", deleteTodo);

final _publicHandler = const Pipeline().addMiddleware(handleErrors()).addHandler(_publicRouter.call);
final _protectedHandler = const Pipeline()
    .addMiddleware(checkAuthorization())
    .addMiddleware(handleErrors())
    .addHandler(_protectedRouter.call);

final mainRouter = Router()
  ..mount("/api/", _publicHandler)
  ..mount("/api/protected", _protectedHandler);

void main(List<String> args) async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  // Use any available host or container IP (usually `0.0.0.0`).
  AppConfig.init(env["SECRET_KEY"]);
  final ip = InternetAddress.anyIPv4;
  // Configure a pipeline that logs requests.

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(mainRouter.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment["PORT"] ?? "8080");
  final server = await serve(handler, ip, port);
  print("Server listening on port ${server.port}");
}
