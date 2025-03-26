import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/driver_controller.dart';

class DriverRoutes {
  Router get router {
    final router = Router();

    router.post('/register', (Request req) async {
      final payload = await req.readAsString();
      final data = json.decode(payload);
      return Response.ok(
        json.encode(await DriverController.registerDriver(data)),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.put('/update-location', (Request req) async {
      final payload = await req.readAsString();
      final data = json.decode(payload);
      return Response.ok(
        json.encode(await DriverController.updateLocation(data)),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.get('/drivers', (Request req) async {
      return Response.ok(
        json.encode(await DriverController.getDrivers()),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.delete('/delete-driver', (Request req) async {
      final payload = await req.readAsString();
      final data = json.decode(payload);
      return Response.ok(
        json.encode(await DriverController.deleteDriver(data['registrationNumber'])),
        headers: {'Content-Type': 'application/json'},
      );
    });

    return router;
  }
}
