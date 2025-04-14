import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriversListScreen extends StatefulWidget {
  const DriversListScreen({super.key});

  @override
  State<DriversListScreen> createState() => _DriversListScreenState();
}

class _DriversListScreenState extends State<DriversListScreen> {
  // Real data - fetched from API
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _filteredDrivers = [];

  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAllDrivers();
  }

  // Fetch all approved drivers from API
  Future<void> _fetchAllDrivers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Directly fetch from API
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.get(
        Uri.parse('${ApiService.adminEndpoint}/drivers'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      print('All Drivers API Response Status: ${response.statusCode}');
      print('All Drivers API Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the response body directly
        final List<dynamic> driversData = json.decode(response.body);

        setState(() {
          _drivers = driversData.map<Map<String, dynamic>>((driver) {
            return {
              'id': driver['_id'] ?? driver['id'],
              'name': driver['name'],
              'mobile': driver['mobileNumber'],
              'vehicleNumber': driver['vehicleNumber'],
              'vehicleType': driver['vehicleType'] ?? 'unknown',
              'status': driver['status'] ?? 'approved',
              'isActive': driver['isActive'] ?? false,
              'registeredAt': driver['registeredAt'] != null
                  ? DateTime.parse(driver['registeredAt'])
                  : DateTime.now(),
              'lastActive': driver['lastLogin'] != null
                  ? DateTime.parse(driver['lastLogin'])
                  : DateTime.now().subtract(const Duration(days: 1)),
            };
          }).toList();

          // Filter out only approved drivers
          _drivers = _drivers
              .where((driver) => driver['status'] == 'approved')
              .toList();

          _filteredDrivers = List.from(_drivers);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching all drivers: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterDrivers(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredDrivers = List.from(_drivers);
      } else {
        _filteredDrivers = _drivers
            .where((driver) =>
                driver['name'].toLowerCase().contains(query.toLowerCase()) ||
                driver['vehicleNumber']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                driver['mobile'].contains(query))
            .toList();
      }
    });
  }

  void _showDriverDetails(Map<String, dynamic> driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
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
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            driver['vehicleNumber'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: driver['isActive']
                            ? AppTheme.secondaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        driver['isActive'] ? 'Online' : 'Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Mobile Number', driver['mobile']),
                    const Divider(),
                    _buildDetailItem('Status', driver['status'].toUpperCase()),
                    const Divider(),
                    _buildDetailItem(
                      'Registered On',
                      '${driver['registeredAt'].day}/${driver['registeredAt'].month}/${driver['registeredAt'].year}',
                    ),
                    const Divider(),
                    _buildDetailItem(
                      'Last Active',
                      _formatLastActive(driver['lastActive']),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Vehicle Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailItem('Type', driver['vehicleType']),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Close the current dialog first
                        // Show delete confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Driver'),
                            content: const Text(
                              'Are you sure you want to delete this driver? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteDriver(driver['id']);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.errorColor),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Delete Driver',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete a driver from the system
  Future<void> _deleteDriver(String driverId) async {
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
                Text("Deleting driver..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Direct API call to delete the driver
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('adminPin') ?? '123456';

      final response = await http.delete(
        Uri.parse('${ApiService.adminEndpoint}/drivers/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'adminPin': adminPin,
        },
      );

      // Close the loading dialog
      Navigator.pop(context);

      print('Delete API Response: ${response.statusCode}');
      print('Delete API Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Update local state to reflect the change
        setState(() {
          _drivers.removeWhere((driver) => driver['id'] == driverId);
          _filteredDrivers = List.from(_drivers);
        });

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Driver deleted successfully'),
            backgroundColor: AppTheme.secondaryColor,
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

  String _formatLastActive(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'All Drivers',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, vehicle number or mobile',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: _filterDrivers,
            ),
          ),

          // Stats bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Total Drivers: ${_drivers.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Active: ${_drivers.where((d) => d['isActive']).length}',
                    style: const TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchAllDrivers,
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),

          // Drivers list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: AppTheme.errorColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading drivers',
                              style: AppTheme.subheadingStyle,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: AppTheme.secondaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchAllDrivers,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _filteredDrivers.isEmpty
                        ? Center(
                            child: _searchQuery.isEmpty
                                ? const Text('No drivers found')
                                : const Text('No drivers match your search'),
                          )
                        : ListView.builder(
                            itemCount: _filteredDrivers.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              final driver = _filteredDrivers[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                child: ListTile(
                                  onTap: () => _showDriverDetails(driver),
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: driver['isActive']
                                        ? AppTheme.secondaryColor
                                        : Colors.grey,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    driver['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(driver['vehicleNumber']),
                                      Text(
                                        driver['mobile'],
                                        style: const TextStyle(
                                          color: AppTheme.secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: driver['isActive']
                                          ? AppTheme.secondaryColor
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      driver['isActive'] ? 'Online' : 'Offline',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
