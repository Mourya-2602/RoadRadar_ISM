import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/map_widget.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final String _driverName = 'John Doe'; // In real app, get from Firebase
  bool _isLocationSharing = false;
  final bool _isVerified = true; // In real app, get from Firebase

  void _toggleLocationSharing() {
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
      _isLocationSharing = !_isLocationSharing;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLocationSharing
            ? 'Location sharing started'
            : 'Location sharing stopped'),
        backgroundColor: _isLocationSharing
            ? AppTheme.secondaryColor
            : AppTheme.errorColor,
        duration: Duration(seconds: 1),
      ),
    );
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
                onTap: () {
                  Navigator.pop(context);
                  // In real app, implement logout logic
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
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
                Switch(
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
                child: MapWidget(),
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
                    _isLocationSharing ? Icons.check_circle : Icons.cancel,
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
