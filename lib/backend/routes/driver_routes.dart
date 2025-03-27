import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/driver_controller.dart';

class DriverRoutes {
  Router get router {
    final router = Router();

    // Route to add/register a new driver
    router.post('/api/', (Request req) async {
      try {
        final payload = await req.readAsString();
        final data = json.decode(payload);
        return Response.ok(
          json.encode(await DriverController.registerDriver(data)),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(body: 'Error registering driver: $e');
      }
    });

    // Route to update an existing driver's details
    router.put('/api', (Request req) async {
      try {
        final payload = await req.readAsString();
        final data = json.decode(payload);
        return Response.ok(
          json.encode(await DriverController.updateDriver(data)),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(body: 'Error updating driver: $e');
      }
    });

    // Route to fetch all drivers
    router.get('/api', (Request req) async {
      try {
        return Response.ok(
          json.encode(await DriverController.getDrivers()),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(body: 'Error fetching drivers: $e');
      }
    });

    // Route to delete a driver
    router.delete('/api', (Request req) async {
      try {
        final payload = await req.readAsString();
        final data = json.decode(payload);
        return Response.ok(
          json.encode(await DriverController.deleteDriver(data['registrationNumber'])),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(body: 'Error deleting driver: $e');
      }
    });

    return router;
  }
}
