import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/driver.dart';

class ApiService {
  // Replace with your actual server URL when deployed
  // static const String baseUrl = 'http://10.0.2.2:5000/api'; // For Android emulator
  // static const String baseUrl = 'http://localhost:5000/api'; // For physical device or iOS simulator

  // Use your actual machine's IP address here
  static const String baseUrl = 'https://roadradar-ism.onrender.com/api';
  // 'http://localhost:5000/api'; // REPLACE X with your actual IP

  static const String driversEndpoint = '$baseUrl/drivers';
  static const String adminEndpoint = '$baseUrl/admin';
  static const String locationsEndpoint = '$baseUrl/locations';

  // Driver Registration
  Future<Map<String, dynamic>> registerDriver(
      Driver driver, String password) async {
    try {
      final Map<String, dynamic> data = driver.toJson();
      data['password'] = password;

      final response = await http.post(
        Uri.parse('$driversEndpoint/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Driver Login
  Future<Map<String, dynamic>> loginDriver(
      String mobileNumber, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$driversEndpoint/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mobileNumber': mobileNumber,
          'password': password,
        }),
      );

      final result = _processResponse(response);

      if (result['error'] == null && result['driver'] != null) {
        // Save driver info in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userType', 'driver');
        await prefs.setString('driverId', result['driver']['id']);
        await prefs.setBool('isLoggedIn', true);
      }

      return result;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Update Driver Location
  Future<Map<String, dynamic>> updateDriverLocation(
      String driverId, double longitude, double latitude) async {
    try {
      final response = await http.put(
        Uri.parse('$driversEndpoint/location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'driverId': driverId,
          'longitude': longitude,
          'latitude': latitude,
        }),
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Toggle Driver Active Status
  Future<Map<String, dynamic>> toggleDriverStatus(
      String driverId, bool isActive) async {
    try {
      final response = await http.put(
        Uri.parse('$driversEndpoint/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'driverId': driverId,
          'isActive': isActive,
        }),
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Get Driver Profile
  Future<Map<String, dynamic>> getDriverProfile(String driverId) async {
    try {
      final response = await http.get(
        Uri.parse('$driversEndpoint/$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Update Driver Profile
  Future<Map<String, dynamic>> updateDriverProfile(
      String driverId, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$driversEndpoint/$driverId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Admin Login
  Future<Map<String, dynamic>> loginAdmin(String pin) async {
    try {
      // No need for a real API call, just validate the PIN
      final prefs = await SharedPreferences.getInstance();
      const adminPin = '123456'; // This should be stored more securely

      if (pin == adminPin) {
        await prefs.setString('userType', 'admin');
        await prefs.setBool('isLoggedIn', true);
        return {'success': true};
      } else {
        return {'error': 'Invalid admin PIN'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Get All Drivers (Admin)
  Future<Map<String, dynamic>> getAllDrivers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.get(
        Uri.parse('$adminEndpoint/drivers'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Get Pending Drivers (Admin)
  Future<Map<String, dynamic>> getPendingDrivers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.get(
        Uri.parse('$adminEndpoint/pending'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Get Active Drivers (Admin)
  Future<Map<String, dynamic>> getActiveDrivers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.get(
        Uri.parse('$adminEndpoint/active'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Approve Driver (Admin)
  Future<Map<String, dynamic>> approveDriver(String driverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.put(
        Uri.parse('$adminEndpoint/approve/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Reject Driver (Admin)
  Future<Map<String, dynamic>> rejectDriver(String driverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.put(
        Uri.parse('$adminEndpoint/reject/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Delete Driver (Admin)
  Future<Map<String, dynamic>> deleteDriver(String driverId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.delete(
        Uri.parse('$adminEndpoint/drivers/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      return _processResponse(response);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Get Active Driver Locations
  Future<List<Map<String, dynamic>>> getActiveLocations() async {
    try {
      final response = await http.get(
        Uri.parse(locationsEndpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching locations: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception in getActiveLocations: $e');
      return [];
    }
  }

  // Save User Name (for regular users)
  Future<bool> saveUserName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setString('userType', 'user');
      await prefs.setBool('isLoggedIn', true);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get User Type and Info
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('userType');
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (userType == null || !isLoggedIn) {
        return {'isLoggedIn': false};
      }

      switch (userType) {
        case 'user':
          final userName = prefs.getString('userName') ?? '';
          return {
            'isLoggedIn': true,
            'userType': 'user',
            'name': userName,
          };

        case 'driver':
          final driverId = prefs.getString('driverId');
          if (driverId == null) {
            return {'isLoggedIn': false};
          }

          final driverData = await getDriverProfile(driverId);

          if (driverData['error'] != null) {
            return {'isLoggedIn': false};
          }

          return {
            'isLoggedIn': true,
            'userType': 'driver',
            'driver': driverData,
          };

        case 'admin':
          return {
            'isLoggedIn': true,
            'userType': 'admin',
          };

        default:
          return {'isLoggedIn': false};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Logout (all users)
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('userType');

      // If driver, set isActive to false before logging out
      if (userType == 'driver') {
        final driverId = prefs.getString('driverId');
        if (driverId != null) {
          // Set driver's active status to false
          await toggleDriverStatus(driverId, false);
        }
      }

      await prefs.setBool('isLoggedIn', false);

      // Keep user type and ID for easier re-login
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  // Helper method to process HTTP responses
  Map<String, dynamic> _processResponse(http.Response response) {
    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }

      final responseData = json.decode(response.body);
      print('Decoded Response Data: $responseData');

      if (responseData is List) {
        print('Response is a List, wrapping in data key');
        return {'data': responseData};
      }
      return responseData;
    } else {
      try {
        return {
          'error': json.decode(response.body)['message'] ?? 'Unknown error'
        };
      } catch (e) {
        return {'error': 'Server error: ${response.statusCode}'};
      }
    }
  }
}
