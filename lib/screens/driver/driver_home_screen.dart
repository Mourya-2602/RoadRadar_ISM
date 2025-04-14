import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/map_widget.dart';
import '../../services/api_service.dart';
import '../../services/location_sharing_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final ApiService _apiService = ApiService();
  final LocationSharingService _locationService = LocationSharingService();

  String _driverName = 'Driver';
  bool _isLocationSharing = false;
  bool _isVerified = false;
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _driverData;

  @override
  void initState() {
    super.initState();
    _loadDriverProfile();
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  Future<void> _loadDriverProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get driver ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getString('driverId');

      if (driverId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Driver ID not found. Please login again.';
        });
        return;
      }

      // Fetch driver profile from API
      final response = await _apiService.getDriverProfile(driverId);

      if (response['error'] != null) {
        setState(() {
          _isLoading = false;
          _errorMessage = response['error'];
        });
        return;
      }

      // Check if location sharing is already active
      final isActive = await _locationService.isActive();

      setState(() {
        _driverData = response;
        _driverName = _driverData!['name'] ?? 'Driver';
        _isVerified = _driverData!['status'] == 'approved';
        _isLocationSharing = isActive;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load profile. Please try again.';
      });
    }
  }

  Future<void> _toggleLocationSharing() async {
    if (!_isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Your account is pending verification. You cannot share location yet.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get driver ID
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getString('driverId');

      if (driverId == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver ID not found. Please login again.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      bool success;
      if (_isLocationSharing) {
        // Stop sharing location
        success = await _locationService.stopSharing();
        if (success) {
          // Update isActive status in MongoDB
          final response =
              await _apiService.toggleDriverStatus(driverId, false);
          if (response['error'] != null) {
            throw Exception(response['error']);
          }
        }
      } else {
        // Request permission before starting
        bool hasPermission = await _locationService.requestLocationPermission();
        if (!hasPermission) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Location permission denied. Cannot share location.'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Start sharing location
        success = await _locationService.startSharing();
        if (success) {
          // Update isActive status in MongoDB
          final response = await _apiService.toggleDriverStatus(driverId, true);
          if (response['error'] != null) {
            throw Exception(response['error']);
          }
        }
      }

      if (success) {
        setState(() {
          _isLocationSharing = !_isLocationSharing;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isLocationSharing
                ? 'Location sharing started'
                : 'Location sharing stopped'),
            backgroundColor: _isLocationSharing
                ? AppTheme.secondaryColor
                : AppTheme.errorColor,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update location sharing status'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        title: const Text(
          'Driver Dashboard',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.driverProfile);
            },
            icon: const Icon(
              Icons.person,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 36,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _driverName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isVerified
                            ? AppTheme.secondaryColor
                            : AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isVerified ? 'Verified' : 'Pending Verification',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                selected: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AppRoutes.driverProfile);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  // Stop location sharing if active
                  if (_isLocationSharing) {
                    await _locationService.stopSharing();
                  }

                  // Logout from API
                  await _apiService.logout();

                  if (!mounted) return;
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
      body: _isLoading && _driverData == null
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _driverData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: AppTheme.errorColor),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppTheme.errorColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDriverProfile,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Location sharing toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
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
                          Icon(
                            Icons.location_on,
                            color: _isLocationSharing
                                ? AppTheme.secondaryColor
                                : AppTheme.secondaryTextColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isLocationSharing
                                      ? 'Sharing Location'
                                      : 'Location Sharing Off',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _isLocationSharing
                                      ? 'Your location is visible to users'
                                      : 'Turn on to start sharing your location',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Switch(
                                  value: _isLocationSharing,
                                  onChanged: (_) => _toggleLocationSharing(),
                                  activeColor: AppTheme.secondaryColor,
                                ),
                        ],
                      ),
                    ),

                    // Map
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: MapWidget(
                            currentUserId: _driverData?['id'],
                          ),
                        ),
                      ),
                    ),

                    // Status bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isLocationSharing
                                  ? AppTheme.secondaryColor.withOpacity(0.1)
                                  : AppTheme.errorColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isLocationSharing
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: _isLocationSharing
                                  ? AppTheme.secondaryColor
                                  : AppTheme.errorColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _isLocationSharing ? 'Active' : 'Inactive',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            _isLocationSharing ? 'Online' : 'Offline',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _isLocationSharing
                                  ? AppTheme.secondaryColor
                                  : AppTheme.errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
