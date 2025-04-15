import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/map_widget.dart';
import '../../services/api_service.dart';
import '../../models/driver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  // Real data - fetched from API
  List<Map<String, dynamic>> _pendingDrivers = [];
  List<Map<String, dynamic>> _activeDrivers = [];

  bool _isLoadingPending = true;
  bool _isLoadingActive = true;
  String? _pendingError;
  String? _activeError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchPendingDrivers();
    _fetchActiveDrivers();
  }

  // Fetch pending drivers from API
  Future<void> _fetchPendingDrivers() async {
    setState(() {
      _isLoadingPending = true;
      _pendingError = null;
    });

    try {
      // Directly fetch from API without using wrapper - for debugging
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.get(
        Uri.parse('${ApiService.adminEndpoint}/pending'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      print('Direct API Response Status: ${response.statusCode}');
      print('Direct API Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the response body directly
        final List<dynamic> driversData = json.decode(response.body);

        setState(() {
          _pendingDrivers = driversData.map<Map<String, dynamic>>((driver) {
            return {
              'id': driver['_id'] ?? driver['id'],
              'name': driver['name'],
              'mobile': driver['mobileNumber'],
              'vehicleNumber': driver['vehicleNumber'],
              'vehicleType': driver['vehicleType'] ?? 'unknown',
              'registeredAt': driver['registeredAt'] != null
                  ? DateTime.parse(driver['registeredAt'])
                  : DateTime.now(),
            };
          }).toList();
          _isLoadingPending = false;

          print('Directly Parsed Pending Drivers: $_pendingDrivers');
        });
      } else {
        setState(() {
          _pendingError = 'Server error: ${response.statusCode}';
          _isLoadingPending = false;
        });
      }
    } catch (e) {
      print('Error fetching pending drivers: $e');
      setState(() {
        _pendingError = e.toString();
        _isLoadingPending = false;
      });
    }
  }

  // Fetch active drivers from API
  Future<void> _fetchActiveDrivers() async {
    setState(() {
      _isLoadingActive = true;
      _activeError = null;
    });

    try {
      // Directly fetch from API without using wrapper - for debugging
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.get(
        Uri.parse('${ApiService.adminEndpoint}/active'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      print('Direct API Response Status (Active): ${response.statusCode}');
      print('Direct API Response Body (Active): ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the response body directly
        final List<dynamic> driversData = json.decode(response.body);

        setState(() {
          _activeDrivers = driversData.map<Map<String, dynamic>>((driver) {
            return {
              'id': driver['_id'] ?? driver['id'],
              'name': driver['name'],
              'mobile': driver['mobileNumber'],
              'vehicleNumber': driver['vehicleNumber'],
              'vehicleType': driver['vehicleType'] ?? 'unknown',
              'isActive': driver['isActive'] ?? false,
              'lastActive': driver['lastLogin'] != null
                  ? DateTime.parse(driver['lastLogin'])
                  : DateTime.now(),
            };
          }).toList();
          _isLoadingActive = false;

          print('Directly Parsed Active Drivers: $_activeDrivers');
        });
      } else {
        setState(() {
          _activeError = 'Server error: ${response.statusCode}';
          _isLoadingActive = false;
        });
      }
    } catch (e) {
      print('Error fetching active drivers: $e');
      setState(() {
        _activeError = e.toString();
        _isLoadingActive = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _approveDriver(String driverId) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Approving driver..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Direct API call to approve the driver
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.put(
        Uri.parse('${ApiService.adminEndpoint}/approve/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      // Close the loading dialog
      Navigator.pop(context);

      print('Approve API Response: ${response.statusCode}');
      print('Approve API Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Update local state to reflect the change
        setState(() {
          final driver =
              _pendingDrivers.firstWhere((driver) => driver['id'] == driverId);
          _pendingDrivers.removeWhere((driver) => driver['id'] == driverId);
        });

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver approved successfully'),
            backgroundColor: AppTheme.secondaryColor,
          ),
        );

        // Refresh active drivers list
        _fetchActiveDrivers();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.reasonPhrase}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _rejectDriver(String driverId) async {
    // Show confirmation dialog
    final bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Driver Application'),
            content: const Text(
                'Are you sure you want to reject and delete this driver\'s application permanently? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style:
                    TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Deleting driver application..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Direct API call to reject the driver
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.put(
        Uri.parse('${ApiService.adminEndpoint}/reject/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      // Close the loading dialog
      Navigator.pop(context);

      print('Reject API Response: ${response.statusCode}');
      print('Reject API Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Update local state to reflect the change
        setState(() {
          _pendingDrivers.removeWhere((driver) => driver['id'] == driverId);
        });

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver application deleted'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.reasonPhrase}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _viewAllDrivers() {
    Navigator.of(context).pushNamed(AppRoutes.adminDriversList);
  }

  // Show driver details in a modal bottom sheet
  void _showDriverDetails(Map<String, dynamic> driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Bottom sheet handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_add,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Driver Application',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDate(driver['registeredAt']),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Info
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Full Name', driver['name']),
                    _buildInfoRow('Mobile Number', driver['mobile']),

                    const SizedBox(height: 24),

                    // Vehicle Info
                    const Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Vehicle Number', driver['vehicleNumber']),
                    _buildInfoRow('Vehicle Type', driver['vehicleType']),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _rejectDriver(driver['id']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.errorColor,
                        elevation: 0,
                        side: const BorderSide(color: AppTheme.errorColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _approveDriver(driver['id']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Approve'),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.secondaryTextColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPlaceholder(String title) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.insert_drive_file_outlined,
            color: AppTheme.secondaryTextColor,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap to view',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
            ),
          ),
        ],
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
          'Admin Dashboard',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // In real app, implement logout
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.roleSelection);
            },
            icon: const Icon(
              Icons.logout,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.secondaryTextColor,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
            Tab(text: 'Active', icon: Icon(Icons.directions_car)),
            Tab(text: 'Map', icon: Icon(Icons.map)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pending Requests Tab
          _buildPendingRequestsTab(),

          // Active Drivers Tab
          _buildActiveDriversTab(),

          // Map Tab
          _buildMapTab(),
        ],
      ),
    );
  }

  Widget _buildPendingRequestsTab() {
    if (_isLoadingPending) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pendingError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 8),
            Text(
              _pendingError!,
              style: const TextStyle(color: AppTheme.secondaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPendingDrivers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Pending Requests (${_pendingDrivers.length})',
                style: AppTheme.subheadingStyle,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
                onPressed: _fetchPendingDrivers,
                tooltip: 'Refresh Pending Requests',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _pendingDrivers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: AppTheme.secondaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No pending requests',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _pendingDrivers.length,
                    itemBuilder: (context, index) {
                      final driver = _pendingDrivers[index];
                      return _buildDriverRequestCard(driver);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildActiveDriversTab() {
    if (_isLoadingActive) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_activeError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 8),
            Text(
              _activeError!,
              style: const TextStyle(color: AppTheme.secondaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchActiveDrivers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final activeDrivers =
        _activeDrivers.where((driver) => driver['isActive'] == true).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Text(
                'Active Drivers (${activeDrivers.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _viewAllDrivers,
                child: const Text('View All'),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
                onPressed: _fetchActiveDrivers,
                tooltip: 'Refresh Active Drivers',
              ),
            ],
          ),
        ),
        Expanded(
          child: activeDrivers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 64,
                        color: AppTheme.secondaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No active drivers',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: activeDrivers.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final driver = activeDrivers[index];
                    return _buildActiveDriverCard(driver);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMapTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_activeDrivers.where((d) => d['isActive'] == true).length} Active',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_activeDrivers.where((d) => d['isActive'] == false).length} Inactive',
                      style: const TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // Refresh map
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Refreshing map...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.refresh,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: MapWidget(),
        ),
      ],
    );
  }

  Widget _buildDriverRequestCard(Map<String, dynamic> driver) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Applied on: ${_formatDate(driver['registeredAt'])}',
                      style: const TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showDriverDetails(driver),
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mobile',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        driver['mobile'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vehicle',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        driver['vehicleNumber'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectDriver(driver['id']),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      side: const BorderSide(color: AppTheme.errorColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _approveDriver(driver['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveDriverCard(Map<String, dynamic> driver) {
    final lastActive = driver['lastActive'] as DateTime;
    final minutesAgo = DateTime.now().difference(lastActive).inMinutes;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    driver['vehicleNumber'],
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    driver['mobile'],
                    style: const TextStyle(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$minutesAgo min ago',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to refresh data when coming back to the screen
  void _refreshData() {
    _fetchPendingDrivers();
    _fetchActiveDrivers();
  }
}
