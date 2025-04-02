import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/driver_model.dart';
import '../models/admin_model.dart';
import 'database_service.dart';

// User type enum - moved outside the class
enum UserType {
  user,
  driver,
  admin,
  none,
}

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userTypeKey = 'user_type';

  static UserModel? _currentUser;
  static DriverModel? _currentDriver;
  static AdminModel? _currentAdmin;

  // Get current logged in user type
  static Future<UserType> getCurrentUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeStr = prefs.getString(_userTypeKey);

    if (userTypeStr == null) {
      return UserType.none;
    }

    switch (userTypeStr) {
      case 'user':
        return UserType.user;
      case 'driver':
        return UserType.driver;
      case 'admin':
        return UserType.admin;
      default:
        return UserType.none;
    }
  }

  // Check if a user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    return token != null && token.isNotEmpty;
  }

  // Get current user
  static Future<UserModel?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    final userType = await getCurrentUserType();
    if (userType != UserType.user) {
      return null;
    }

    // Load user from token
    final token = await _getToken();
    if (token == null) {
      return null;
    }

    try {
      // Parse token (in a real app this would be a JWT)
      final parts = token.split('.');
      if (parts.length < 2) {
        return null;
      }

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final email = payload['email'];
      final user = await DatabaseService.getUserByEmail(email);

      _currentUser = user;
      return user;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Get current driver
  static Future<DriverModel?> getCurrentDriver() async {
    if (_currentDriver != null) {
      return _currentDriver;
    }

    final userType = await getCurrentUserType();
    if (userType != UserType.driver) {
      return null;
    }

    // Load driver from token
    final token = await _getToken();
    if (token == null) {
      return null;
    }

    try {
      // Parse token (in a real app this would be a JWT)
      final parts = token.split('.');
      if (parts.length < 2) {
        return null;
      }

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final email = payload['email'];
      final driver = await DatabaseService.getDriverByEmail(email);

      _currentDriver = driver;
      return driver;
    } catch (e) {
      print('Error getting current driver: $e');
      return null;
    }
  }

  // Get current admin
  static Future<AdminModel?> getCurrentAdmin() async {
    if (_currentAdmin != null) {
      return _currentAdmin;
    }

    final userType = await getCurrentUserType();
    if (userType != UserType.admin) {
      return null;
    }

    // Load admin from token
    final token = await _getToken();
    if (token == null) {
      return null;
    }

    try {
      // Parse token (in a real app this would be a JWT)
      final parts = token.split('.');
      if (parts.length < 2) {
        return null;
      }

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      final email = payload['email'];
      final admin = await DatabaseService.getAdminByEmail(email);

      _currentAdmin = admin;
      return admin;
    } catch (e) {
      print('Error getting current admin: $e');
      return null;
    }
  }

  // User login
  static Future<UserModel?> loginUser(String email, String password) async {
    try {
      final user = await DatabaseService.getUserByEmail(email);

      if (user == null) {
        return null;
      }

      // Verify password (this is a simplified example)
      // In a real app, you would use proper password hashing
      final hashedPassword = _hashPassword(password);

      // Check password (in a real DB, you would store the hash)
      // This is just for demonstration
      if (hashedPassword != 'stored_hash_here') {
        return null;
      }

      // Generate auth token
      final token = _generateToken(user.email, UserType.user);

      // Store token and user type
      await _saveToken(token, UserType.user);

      // Update last login
      final updatedUser = user.copyWith(
        lastLogin: DateTime.now(),
      );

      await DatabaseService.updateUser(updatedUser);

      _currentUser = updatedUser;
      return updatedUser;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Driver login with mobile number
  static Future<DriverModel?> loginDriverWithMobile(
      String mobileNumber, String password) async {
    try {
      final driver = await DatabaseService.getDriverByMobile(mobileNumber);

      if (driver == null) {
        return null;
      }

      // Verify password (this is a simplified example)
      final hashedPassword = _hashPassword(password);

      // Check password (in a real DB, you would store the hash)
      if (hashedPassword != 'stored_hash_here') {
        return null;
      }

      // Generate auth token
      final token = _generateToken(driver.email, UserType.driver);

      // Store token and user type
      await _saveToken(token, UserType.driver);

      // Update last login
      final updatedDriver = driver.copyWith(
        lastLogin: DateTime.now(),
      );

      await DatabaseService.updateDriver(updatedDriver);

      _currentDriver = updatedDriver;
      return updatedDriver;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Driver login with vehicle number
  static Future<DriverModel?> loginDriverWithVehicle(
      String vehicleNumber, String password) async {
    try {
      final driver =
          await DatabaseService.getDriverByVehicleNumber(vehicleNumber);

      if (driver == null) {
        return null;
      }

      // Verify password (this is a simplified example)
      final hashedPassword = _hashPassword(password);

      // Check password (in a real DB, you would store the hash)
      if (hashedPassword != 'stored_hash_here') {
        return null;
      }

      // Generate auth token
      final token = _generateToken(driver.email, UserType.driver);

      // Store token and user type
      await _saveToken(token, UserType.driver);

      // Update last login
      final updatedDriver = driver.copyWith(
        lastLogin: DateTime.now(),
      );

      await DatabaseService.updateDriver(updatedDriver);

      _currentDriver = updatedDriver;
      return updatedDriver;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Admin login
  static Future<AdminModel?> loginAdmin(String email, String password) async {
    try {
      final admin = await DatabaseService.getAdminByEmail(email);

      if (admin == null) {
        return null;
      }

      // Verify password (this is a simplified example)
      final hashedPassword = _hashPassword(password);

      // Check password (in a real DB, you would store the hash)
      if (hashedPassword != 'stored_hash_here') {
        return null;
      }

      // Generate auth token
      final token = _generateToken(admin.email, UserType.admin);

      // Store token and user type
      await _saveToken(token, UserType.admin);

      // Update last login
      final updatedAdmin = admin.copyWith(
        lastLogin: DateTime.now(),
      );

      await DatabaseService.updateAdmin(updatedAdmin);

      _currentAdmin = updatedAdmin;
      return updatedAdmin;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Register a new user
  static Future<UserModel?> registerUser(
    String name,
    String email,
    String mobileNumber,
    String password,
  ) async {
    try {
      // Check if user already exists
      final existingUserByEmail = await DatabaseService.getUserByEmail(email);
      if (existingUserByEmail != null) {
        throw Exception('Email already in use');
      }

      final existingUserByMobile =
          await DatabaseService.getUserByMobile(mobileNumber);
      if (existingUserByMobile != null) {
        throw Exception('Mobile number already in use');
      }

      // Create new user
      final newUser = UserModel(
        id: '', // Will be set by MongoDB
        name: name,
        email: email,
        mobileNumber: mobileNumber,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        isActive: true,
      );

      // Save user to database
      final createdUser = await DatabaseService.createUser(newUser);

      // Generate auth token
      final token = _generateToken(email, UserType.user);

      // Store token and user type
      await _saveToken(token, UserType.user);

      _currentUser = createdUser;
      return createdUser;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Register a new driver
  static Future<DriverModel?> registerDriver(
    String name,
    String email,
    String mobileNumber,
    String vehicleNumber,
    String password,
    VehicleDetails vehicleDetails,
  ) async {
    try {
      // Check if driver already exists
      final existingDriverByEmail =
          await DatabaseService.getDriverByEmail(email);
      if (existingDriverByEmail != null) {
        throw Exception('Email already in use');
      }

      final existingDriverByMobile =
          await DatabaseService.getDriverByMobile(mobileNumber);
      if (existingDriverByMobile != null) {
        throw Exception('Mobile number already in use');
      }

      final existingDriverByVehicle =
          await DatabaseService.getDriverByVehicleNumber(vehicleNumber);
      if (existingDriverByVehicle != null) {
        throw Exception('Vehicle number already registered');
      }

      // Create new driver
      final newDriver = DriverModel(
        id: '', // Will be set by MongoDB
        name: name,
        email: email,
        mobileNumber: mobileNumber,
        vehicleNumber: vehicleNumber,
        status: DriverStatus.pending, // New drivers start as pending
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        isActive: true,
        isLocationSharing: false,
        vehicleDetails: vehicleDetails,
        documents: Documents.empty(),
      );

      // Save driver to database
      final createdDriver = await DatabaseService.createDriver(newDriver);

      // Generate auth token
      final token = _generateToken(email, UserType.driver);

      // Store token and user type
      await _saveToken(token, UserType.driver);

      _currentDriver = createdDriver;
      return createdDriver;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userTypeKey);

    _currentUser = null;
    _currentDriver = null;
    _currentAdmin = null;
  }

  // Helper methods
  static Future<void> _saveToken(String token, UserType userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userTypeKey, userType.name);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static String _generateToken(String email, UserType userType) {
    // In a real app, you would use a proper JWT library
    // This is a simplified example

    final header = base64Url.encode(utf8.encode(json.encode({
      'alg': 'HS256',
      'typ': 'JWT',
    })));

    final payload = base64Url.encode(utf8.encode(json.encode({
      'email': email,
      'userType': userType.name,
      'exp':
          DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    })));

    final signature = base64Url.encode(utf8.encode('signature_placeholder'));

    return '$header.$payload.$signature';
  }

  static String _hashPassword(String password) {
    // In a real app, you would use a proper password hashing library
    // This is a simplified example
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
