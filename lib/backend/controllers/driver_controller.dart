import 'package:mongo_dart/mongo_dart.dart';
import '../config/database.dart';

class DriverController {
  // Method to register a new driver
  static Future<Map<String, dynamic>> registerDriver(Map<String, dynamic> driverData) async {
    final collection = Database.getCollection('Drivers');
    await collection.insert(driverData);
    return {"message": "Driver registered successfully!"};
  }

  // Method to update an existing driver's details
  static Future<Map<String, dynamic>> updateDriver(Map<String, dynamic> updatedData) async {
    final collection = Database.getCollection('Drivers');
    try {
      // Parse the ObjectId from the provided _id
      final objectId = ObjectId.fromHexString(updatedData['_id']);

      // Perform the update operation
      final result = await collection.update(
        where.id(objectId),
        modify
          ..set('name', updatedData['name'])
          ..set('mobileNumber', updatedData['mobileNumber'])
          ..set('vehicleType', updatedData['vehicleType'])
          ..set('driverpin', updatedData['driverpin'])
          ..set('speedLimitWarnings', updatedData['speedLimitWarnings']),
      );

        return {"message": "Driver updated successfully!"};
    } catch (e) {
      return {"error": "Invalid ID format or update error: $e"};
    }
  }


  // Method to fetch all drivers
  static Future<List<Map<String, dynamic>>> getDrivers() async {
    final collection = Database.getCollection('Drivers');
    final drivers = await collection.find().toList();
    return drivers;
  }

  // Method to delete a driver
  static Future<Map<String, dynamic>> deleteDriver(String registrationNumber) async {
    final collection = Database.getCollection('Drivers');
    final result = await collection.remove(where.eq('registrationNumber', registrationNumber));
    return result['n'] > 0
        ? {"message": "Driver deleted successfully!"}
        : {"message": "Driver not found!"};
  }
}
