import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/map_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data - in real app, get from Firebase
  final List<Map<String, dynamic>> _pendingDrivers = [
    {
      'id': '1',
      'name': 'John Smith',
      'mobile': '9876543210',
      'vehicleNumber': 'KA 01 AB 1234',
      'registeredAt': DateTime(2023, 1, 15),
      'vehicleDetails': {
        'type': 'Sedan',
        'model': 'Toyota Corolla',
        'year': 2020,
      },
    },
    {
      'id': '2',
      'name': 'Jane Doe',
      'mobile': '8765432109',
      'vehicleNumber': 'KA 02 CD 5678',
      'registeredAt': DateTime(2023, 2, 20),
      'vehicleDetails': {
        'type': 'SUV',
        'model': 'Honda CR-V',
        'year': 2021,
      },
    },
    {
      'id': '3',
      'name': 'Robert Williams',
      'mobile': '7654321098',
      'vehicleNumber': 'KA 03 EF 9012',
      'registeredAt': DateTime(2023, 3, 10),
      'vehicleDetails': {
        'type': 'Hatchback',
        'model': 'Hyundai i20',
        'year': 2019,
      },
    },
    {
      'id': '4',
      'name': 'Lisa Johnson',
      'mobile': '6543210987',
      'vehicleNumber': 'KA 04 GH 3456',
      'registeredAt': DateTime(2023, 3, 25),
      'vehicleDetails': {
        'type': 'Sedan',
        'model': 'Honda City',
        'year': 2022,
      },
    },
  ];

  final List<Map<String, dynamic>> _activeDrivers = [
    {
      'id': '3',
      'name': 'David Johnson',
      'mobile': '7654321098',
      'vehicleNumber': 'KA 03 EF 9012',
      'isActive': true,
      'lastActive': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'id': '4',
      'name': 'Sarah Williams',
      'mobile': '6543210987',
      'vehicleNumber': 'KA 04 GH 3456',
      'isActive': true,
      'lastActive': DateTime.now().subtract(const Duration(minutes: 15)),
    },
    {
      'id': '5',
      'name': 'Michael Brown',
      'mobile': '5432109876',
      'vehicleNumber': 'KA 05 IJ 7890',
      'isActive': false,
      'lastActive': DateTime.now().subtract(const Duration(hours: 2)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _approveDriver(String driverId) {
    // In real app, update status in Firebase
    setState(() {
      final driver =
          _pendingDrivers.firstWhere((driver) => driver['id'] == driverId);
      _pendingDrivers.removeWhere((driver) => driver['id'] == driverId);
      driver['isActive'] = false;
      driver['lastActive'] = DateTime.now();
      _activeDrivers.add(driver);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Driver approved successfully'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }

  void _rejectDriver(String driverId) {
    // In real app, update status in Firebase
    setState(() {
      _pendingDrivers.removeWhere((driver) => driver['id'] == driverId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Driver rejected'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
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
                    _buildInfoRow(
                        'Vehicle Type', driver['vehicleDetails']['type']),
                    _buildInfoRow(
                        'Vehicle Model', driver['vehicleDetails']['model']),
                    _buildInfoRow('Manufacturing Year',
                        driver['vehicleDetails']['year'].toString()),

                    const SizedBox(height: 24),

                    // Documents Section - Placeholders for real implementation
                    const Text(
                      'Documents',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Placeholder for documents
                    Row(
                      children: [
                        Expanded(
                          child: _buildDocumentPlaceholder('Driver License'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child:
                              _buildDocumentPlaceholder('Vehicle Registration'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDocumentPlaceholder('Insurance'),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
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
                      child: const Text('Reject'),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending Requests (${_pendingDrivers.length})',
            style: AppTheme.subheadingStyle,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'All driver applications have been processed',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      onPressed: () =>
                                          _rejectDriver(driver['id']),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppTheme.errorColor,
                                        side: const BorderSide(
                                            color: AppTheme.errorColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Reject'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _approveDriver(driver['id']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppTheme.secondaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildActiveDriversTab() {
    final activeDrivers =
        _activeDrivers.where((driver) => driver['isActive'] == true).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Drivers (${activeDrivers.length})',
                style: AppTheme.subheadingStyle,
              ),
              TextButton(
                onPressed: _viewAllDrivers,
                child: const Text('View All Drivers'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          activeDrivers.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No active drivers right now',
                      style: TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: activeDrivers.length,
                    itemBuilder: (context, index) {
                      final driver = activeDrivers[index];
                      final lastActive = driver['lastActive'] as DateTime;
                      final minutesAgo =
                          DateTime.now().difference(lastActive).inMinutes;

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
                                  color:
                                      AppTheme.secondaryColor.withOpacity(0.1),
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
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
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
                    },
                  ),
                ),
        ],
      ),
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
}
