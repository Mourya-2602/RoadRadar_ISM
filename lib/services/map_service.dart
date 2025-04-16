import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'api_service.dart';
import 'location_service.dart';
import '../config/theme.dart';

class MapService {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  final String? currentUserId;
  Timer? _driverLocationTimer;

  final mapController = MapController();

  // Markers for the map
  final List<Marker> markers = [];
  final StreamController<List<Marker>> _markersController =
      StreamController<List<Marker>>.broadcast();
  Stream<List<Marker>> get markersStream => _markersController.stream;

  MapService({this.currentUserId});

  // Start tracking drivers
  void startTrackingDrivers() {
    // Set up periodic location updates
    _driverLocationTimer?.cancel();
    _driverLocationTimer = Timer.periodic(
      const Duration(seconds: 1), // Update every 10 seconds
      (timer) => _updateDriverLocations(),
    );

    // Initial update
    _updateDriverLocations();
  }

  // Stop tracking drivers
  void stopTrackingDrivers() {
    _driverLocationTimer?.cancel();
    _driverLocationTimer = null;
  }

  // Get user's current location
  Future<LatLng?> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  // Update driver locations from the server
  Future<void> _updateDriverLocations() async {
    try {
      final locations = await _apiService.getActiveLocations();

      print('Fetched ${locations.length} driver locations from API');

      if (locations.isEmpty) {
        print('No driver locations received from API');
      } else {
        // Log a sample location
        print('Sample location: ${locations.first}');
      }

      markers.clear();

      // Add each driver as a marker
      for (final driverLocation in locations) {
        final marker = Marker(
          width: 40,
          height: 40,
          point:
              LatLng(driverLocation['latitude'], driverLocation['longitude']),
          child: _buildDriverMarker(driverLocation),
        );

        markers.add(marker);
      }

      // Notify listeners
      _markersController.add(List.from(markers));
    } catch (e) {
      print('Error updating driver locations: $e');
    }
  }

  // Build custom marker for driver
  Widget _buildDriverMarker(Map<String, dynamic> driverLocation) {
    final vehicleType = driverLocation['vehicleType'] ?? 'Bus';
    final isCurrentUser = driverLocation['id'] == currentUserId;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppTheme.primaryColor.withOpacity(0.9)
            : Colors.red.withOpacity(0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
          )
        ],
      ),
      child: Center(
        child: Icon(
          _getIconForVehicleType(vehicleType),
          color: Colors.white,
          size: 20.0,
        ),
      ),
    );
  }

  // Get appropriate icon for vehicle type
  IconData _getIconForVehicleType(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bus':
        return Icons.directions_bus;
      case 'car':
        return Icons.directions_car;
      case 'truck':
        return Icons.local_shipping;
      default:
        return Icons.directions_car_filled_rounded;
    }
  }

  // Center map on user location
  Future<void> centerOnUserLocation({double zoom = 15.0}) async {
    final userLocation = await getCurrentLocation();

    if (userLocation != null) {
      mapController.move(userLocation, zoom);
    }
  }

  // Center map on specific location
  void centerOnLocation(LatLng location, {double zoom = 15.0}) {
    mapController.move(location, zoom);
  }

  // Dispose resources
  void dispose() {
    _driverLocationTimer?.cancel();
    _markersController.close();
    mapController.dispose();
  }
}
