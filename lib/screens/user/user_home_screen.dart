import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/map_widget.dart';
import '../../services/api_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String _userName = 'User';
  int _activeDrivers = 0; // Will be updated from API
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchActiveDrivers();
  }

  // Load the user name from SharedPreferences
  Future<void> _loadUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('userName');
      if (name != null && name.isNotEmpty) {
        setState(() {
          _userName = name;
        });
      }
    } catch (e) {
      // Handle error silently
      print('Error loading user name: $e');
    }
  }

  // Fetch the number of active drivers
  Future<void> _fetchActiveDrivers() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final locations = await _apiService.getActiveLocations();

      setState(() {
        _activeDrivers = locations.length;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching active drivers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Handle logout
  Future<void> _handleLogout() async {
    try {
      final result = await _apiService.logout();
      if (result) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to logout. Please try again.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }

  // Refresh map and active drivers
  Future<void> _refreshData() async {
    await _fetchActiveDrivers();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Map refreshed'),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello $_userName',
                        style: AppTheme.headingStyle,
                      ),
                      // Logout button instead of profile icon
                      GestureDetector(
                        onTap: _handleLogout,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.logout,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '$_activeDrivers active drivers nearby',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      if (_isLoading)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 16,
                          height: 16,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Map section
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
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
                  child: MapWidget(),
                ),
              ),
            ),

            // Bottom section - location permission status and refresh button
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Location services enabled',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : _refreshData,
                    icon: const Icon(
                      Icons.refresh,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
