import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

import '../models/user_model.dart';
import '../models/driver_model.dart';
import '../models/admin_model.dart';

class DatabaseService {
  static Db? _db;
  static bool _isConnected = false;
  static const String _dbName = 'road_radar';

  // Collection names
  static const String _usersCollection = 'users';
  static const String _driversCollection = 'drivers';
  static const String _adminsCollection = 'admins';
  static const String _locationsCollection = 'locations';
  static const String _sessionsCollection = 'sessions';

  // Get database connection URL
  static String get _dbUrl {
    // Try to get URL from environment variables
    final dbUrl = dotenv.env['MONGODB_URL'];
    if (dbUrl != null && dbUrl.isNotEmpty) {
      return dbUrl;
    }

    // Default local connection
    return 'mongodb://localhost:27017/$_dbName';
  }

  // Initialize database connection
  static Future<void> init() async {
    if (_db == null || !_isConnected) {
      try {
        _db = await Db.create(_dbUrl);
        await _db!.open();
        _isConnected = true;

        // Create indexes for geospatial queries
        final driversCollection = _db!.collection(_driversCollection);
        await driversCollection.createIndex(
            key: 'currentLocation', unique: false);

        // Create indexes for user lookup
        final usersCollection = _db!.collection(_usersCollection);
        await usersCollection.createIndex(key: 'email', unique: true);
        await usersCollection.createIndex(key: 'mobileNumber', unique: true);

        // Create indexes for driver lookup
        await driversCollection.createIndex(key: 'email', unique: true);
        await driversCollection.createIndex(key: 'mobileNumber', unique: true);
        await driversCollection.createIndex(key: 'vehicleNumber', unique: true);

        print('Database connected successfully!');
      } catch (e) {
        print('Database connection error: $e');
        _isConnected = false;
        rethrow;
      }
    }
  }

  // Close database connection
  static Future<void> close() async {
    if (_db != null && _isConnected) {
      await _db!.close();
      _isConnected = false;
    }
  }

  // Check if connected
  static bool get isConnected => _isConnected;

  // Get a collection reference
  static DbCollection _getCollection(String collectionName) {
    if (!_isConnected || _db == null) {
      throw Exception('Database not connected');
    }

    return _db!.collection(collectionName);
  }

  // User operations
  static Future<UserModel?> getUserByEmail(String email) async {
    final collection = _getCollection(_usersCollection);
    final result = await collection.findOne(where.eq('email', email));

    if (result == null) {
      return null;
    }

    return UserModel.fromJson(result);
  }

  static Future<UserModel?> getUserByMobile(String mobileNumber) async {
    final collection = _getCollection(_usersCollection);
    final result =
        await collection.findOne(where.eq('mobileNumber', mobileNumber));

    if (result == null) {
      return null;
    }

    return UserModel.fromJson(result);
  }

  static Future<UserModel> createUser(UserModel user) async {
    final collection = _getCollection(_usersCollection);
    final result = await collection.insert(user.toJson());

    return user.copyWith(id: result.toString());
  }

  static Future<UserModel?> updateUser(UserModel user) async {
    final collection = _getCollection(_usersCollection);
    final result = await collection.update(
      where.eq('_id', user.id),
      user.toJson(),
    );

    return user;
  }

  // Driver operations
  static Future<DriverModel?> getDriverByEmail(String email) async {
    final collection = _getCollection(_driversCollection);
    final result = await collection.findOne(where.eq('email', email));

    if (result == null) {
      return null;
    }

    return DriverModel.fromJson(result);
  }

  static Future<DriverModel?> getDriverByMobile(String mobileNumber) async {
    final collection = _getCollection(_driversCollection);
    final result =
        await collection.findOne(where.eq('mobileNumber', mobileNumber));

    if (result == null) {
      return null;
    }

    return DriverModel.fromJson(result);
  }

  static Future<DriverModel?> getDriverByVehicleNumber(
      String vehicleNumber) async {
    final collection = _getCollection(_driversCollection);
    final result =
        await collection.findOne(where.eq('vehicleNumber', vehicleNumber));

    if (result == null) {
      return null;
    }

    return DriverModel.fromJson(result);
  }

  static Future<DriverModel> createDriver(DriverModel driver) async {
    final collection = _getCollection(_driversCollection);
    final result = await collection.insert(driver.toJson());

    return driver.copyWith(id: result.toString());
  }

  static Future<DriverModel?> updateDriver(DriverModel driver) async {
    final collection = _getCollection(_driversCollection);
    final result = await collection.update(
      where.eq('_id', driver.id),
      driver.toJson(),
    );

    return driver;
  }

  static Future<List<DriverModel>> getDriversByStatus(
      DriverStatus status) async {
    final collection = _getCollection(_driversCollection);
    final result =
        await collection.find(where.eq('status', status.name)).toList();

    return result.map((e) => DriverModel.fromJson(e)).toList();
  }

  static Future<List<DriverModel>> getNearbyDrivers(
      double latitude, double longitude, double radiusKm) async {
    final collection = _getCollection(_driversCollection);

    // Create a geospatial query
    final query = {
      'currentLocation': {
        '\$near': {
          '\$geometry': {
            'type': 'Point',
            'coordinates': [longitude, latitude]
          },
          '\$maxDistance': radiusKm * 1000 // Convert to meters
        }
      },
      'status': DriverStatus.approved.name,
      'isActive': true,
      'isLocationSharing': true
    };

    final result = await collection.find(query).toList();
    return result.map((e) => DriverModel.fromJson(e)).toList();
  }

  // Admin operations
  static Future<AdminModel?> getAdminByEmail(String email) async {
    final collection = _getCollection(_adminsCollection);
    final result = await collection.findOne(where.eq('email', email));

    if (result == null) {
      return null;
    }

    return AdminModel.fromJson(result);
  }

  static Future<AdminModel> createAdmin(AdminModel admin) async {
    final collection = _getCollection(_adminsCollection);
    final result = await collection.insert(admin.toJson());

    return admin.copyWith(id: result.toString());
  }

  static Future<AdminModel?> updateAdmin(AdminModel admin) async {
    final collection = _getCollection(_adminsCollection);
    final result = await collection.update(
      where.eq('_id', admin.id),
      admin.toJson(),
    );

    return admin;
  }

  static Future<List<AdminModel>> getAllAdmins() async {
    final collection = _getCollection(_adminsCollection);
    final result = await collection.find().toList();

    return result.map((e) => AdminModel.fromJson(e)).toList();
  }
}
