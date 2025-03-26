import 'package:mongo_dart/mongo_dart.dart';
import 'package:road_radar/backend/config/constant.dart';
import '../config/database.dart';

class DriverController {
  static Future<Map<String, dynamic>> registerDriver(Map<String, dynamic> driverData) async {
    final collection = Database.getCollection(USER_COLLECTION);
    await collection.insert(driverData);
    return {"message": "Driver registered successfully!"};
  }

  static Future<Map<String, dynamic>> updateLocation(Map<String, dynamic> locationData) async {
    final collection = Database.getCollection(USER_COLLECTION);
    final result = await collection.update(
      where.eq('registrationNumber', locationData['registrationNumber']),
      modify.set('location', locationData['location']),
    );
    return result['updatedExisting'] == true
        ? {"message": "Driver location updated successfully!"}
        : {"message": "Driver not found!"};
  }

  static Future<List<Map<String, dynamic>>> getDrivers() async {
    final collection = Database.getCollection(USER_COLLECTION);
    final drivers = await collection.find().toList();
    return drivers;
  }

  static Future<Map<String, dynamic>> deleteDriver(String registrationNumber) async {
    final collection = Database.getCollection(USER_COLLECTION);
    final result = await collection.remove(where.eq('registrationNumber', registrationNumber));
    return result['n'] > 0
        ? {"message": "Driver deleted successfully!"}
        : {"message": "Driver not found!"};
  }
}
