import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'routes/driver_routes.dart';
import 'config/database.dart';

Future<void> main() async {
  // Connect to MongoDB
  await Database.connect();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(DriverRoutes().router.call);

  final server = await io.serve(handler, 'localhost', 8080);  //server initialization
  print('Server is running on http://localhost:8080');
}
