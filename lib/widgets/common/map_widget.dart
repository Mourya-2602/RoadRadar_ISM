import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/location_service.dart';
import '../../services/map_service.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class MapWidget extends StatefulWidget {
  final String? currentUserId;

  const MapWidget({
    super.key,
    this.currentUserId,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final LocationService _locationService = LocationService();
  late final MapService _mapService;
  LatLng? _currentLocation;
  bool _isLoading = true;
  List<Marker> _markers = [];
  StreamSubscription? _markersSubscription;

  // Define the bounds for the map constraint
  final LatLngBounds _mapBounds = LatLngBounds(
    const LatLng(90, 0), // Southwest corner
    const LatLng(0, 180), // Northeast corner
  );

  @override
  void initState() {
    super.initState();
    _mapService = MapService(currentUserId: widget.currentUserId);
    _setupMarkerSubscription();
    _mapService.startTrackingDrivers();
    _fetchLocation();

    // Add a delay to center on drivers if available
    Future.delayed(Duration(seconds: 2), () {
      if (_markers.isNotEmpty) {
        // Center on the first driver's location
        _mapService.centerOnLocation(_markers[0].point, zoom: 15.0);
        print('Centering map on driver location');
      }
    });
  }

  void _setupMarkerSubscription() {
    _markersSubscription = _mapService.markersStream.listen((markers) {
      setState(() {
        _markers = markers;
      });
    });
  }

  @override
  void dispose() {
    _markersSubscription?.cancel();
    _mapService.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoading = true;
    });
    _currentLocation = await _locationService.getCurrentLocation();
    setState(() {
      _isLoading = false;
    });
    if (_currentLocation != null) {
      // Ensure the initial location is within bounds before moving
      if (_mapBounds.contains(_currentLocation!)) {
        _mapService.centerOnLocation(_currentLocation!, zoom: 15.0);
      } else {
        // If current location is outside bounds, center on the bounds' center
        _mapService.centerOnLocation(_mapBounds.center, zoom: 15.0);
        print(
            "Current location is outside defined bounds. Centering map on bounds.");
      }
    } else {
      // If location fails, center on bounds center
      _mapService.centerOnLocation(_mapBounds.center, zoom: 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapService.mapController,
              options: MapOptions(
                initialCenter: _currentLocation ??
                    _mapBounds.center, // Start at bounds center if no location
                initialZoom: 15.0, // Adjust initial zoom as needed
                // cameraConstraint: CameraConstraint.contain(
                //     bounds: _mapBounds), // Apply the constraint
                // maxZoom: 18.0, // Optional: Set max zoom
                // minZoom:
                //     10.0, // Optional: Set min zoom to prevent zooming out too far
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.road_radar', // Replace with your app's identifier
                ),
                MarkerLayer(
                  markers: [
                    // Current user location marker
                    if (_currentLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentLocation!,
                        child: const Icon(
                          Icons.my_location,
                          color: AppTheme.primaryColor,
                          size: 30.0,
                        ),
                      ),
                    // Add all driver markers
                    ..._markers,
                  ],
                ),
              ],
            ),

            // Loading Indicator
            // if (_isLoading)
            //   Container(
            //     color: Colors.black.withOpacity(0.5),
            //     child: const Center(
            //       child: CircularProgressIndicator(
            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //       ),
            //     ),
            //   ),

            // Error/Permission message
            if (!_isLoading && _currentLocation == null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_off,
                          size: 40, color: AppTheme.secondaryTextColor),
                      SizedBox(height: 10),
                      Text(
                        'Could not get location.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Please enable location services and grant permission.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom info bar (Optional: You can keep it or remove it)
            if (_currentLocation != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your location: (${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)})',
                          style: AppTheme.captionStyle,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.my_location,
                            size: 20, color: AppTheme.primaryColor),
                        onPressed:
                            _fetchLocation, // Button to re-center on current location
                        tooltip: 'Center on my location',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    ],
                  ),
                ),
              ),

            // Add Find Drivers button
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'findDrivers',
                backgroundColor: AppTheme.primaryColor,
                mini: true,
                onPressed: () {
                  if (_markers.isNotEmpty) {
                    // Center on the first driver
                    _mapService.centerOnLocation(_markers[0].point, zoom: 15.0);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Showing nearby drivers'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No drivers available'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Trigger refresh
                    _mapService.startTrackingDrivers();
                  }
                },
                child: Icon(Icons.directions_car, color: Colors.white),
                tooltip: 'Find drivers',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
