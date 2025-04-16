import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class LocationSharingService {
  static final LocationSharingService _instance =
      LocationSharingService._internal();

  factory LocationSharingService() {
    return _instance;
  }

  LocationSharingService._internal();

  final ApiService _apiService = ApiService();
  Timer? _locationTimer;
  bool _isActive = false;
  final Duration _updateInterval = const Duration(seconds: 1);

  // Check if location sharing is currently active
  Future<bool> isActive() async {
    final prefs = await SharedPreferences.getInstance();
    _isActive = prefs.getBool('isLocationSharingActive') ?? false;
    return _isActive;
  }

  // Request location permissions
  Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return false;
    }

    // Permissions are granted
    return true;
  }

  // Start location sharing
  Future<bool> startSharing() async {
    try {
      // Check if already active
      if (_isActive) {
        return true;
      }

      // Get driver ID
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getString('driverId');

      if (driverId == null) {
        debugPrint('Cannot start location sharing: Driver ID not found');
        return false;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Send initial location
      final success = await _updateDriverLocation(driverId, position);
      if (!success) {
        return false;
      }

      // Save status to preferences
      await prefs.setBool('isLocationSharingActive', true);
      _isActive = true;

      // Start periodic location updates
      _locationTimer = Timer.periodic(_updateInterval, (timer) async {
        try {
          final currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          await _updateDriverLocation(driverId, currentPosition);
        } catch (e) {
          debugPrint('Error updating location: $e');
        }
      });

      return true;
    } catch (e) {
      debugPrint('Error starting location sharing: $e');
      return false;
    }
  }

  // Stop location sharing
  Future<bool> stopSharing() async {
    try {
      // Cancel timer if active
      _locationTimer?.cancel();
      _locationTimer = null;

      // Update status in preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLocationSharingActive', false);
      _isActive = false;

      return true;
    } catch (e) {
      debugPrint('Error stopping location sharing: $e');
      return false;
    }
  }

  // Update driver location in the backend
  Future<bool> _updateDriverLocation(String driverId, Position position) async {
    try {
      final response = await _apiService.updateDriverLocation(
        driverId,
        position.longitude,
        position.latitude,
      );

      return response['error'] == null;
    } catch (e) {
      debugPrint('Error updating driver location: $e');
      return false;
    }
  }

  // Cleanup resources
  void dispose() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }
}
