import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';

class DriversListScreen extends StatefulWidget {
  const DriversListScreen({super.key});

  @override
  State<DriversListScreen> createState() => _DriversListScreenState();
}

class _DriversListScreenState extends State<DriversListScreen> {
  // Mock data - in real app, get from Firebase
  final List<Map<String, dynamic>> _drivers = [
    {
      'id': '1',
      'name': 'John Smith',
      'mobile': '9876543210',
      'vehicleNumber': 'KA 01 AB 1234',
      'status': 'approved',
      'isActive': false,
      'registeredAt': DateTime(2023, 1, 15),
      'lastActive': DateTime.now().subtract(const Duration(days: 2)),
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
      'status': 'approved',
      'isActive': false,
      'registeredAt': DateTime(2023, 2, 20),
      'lastActive': DateTime.now().subtract(const Duration(days: 1)),
      'vehicleDetails': {
        'type': 'SUV',
        'model': 'Honda CR-V',
        'year': 2021,
      },
    },
    {
      'id': '3',
      'name': 'David Johnson',
      'mobile': '7654321098',
      'vehicleNumber': 'KA 03 EF 9012',
      'status': 'approved',
      'isActive': true,
      'registeredAt': DateTime(2023, 3, 10),
      'lastActive': DateTime.now().subtract(const Duration(minutes: 5)),
      'vehicleDetails': {
        'type': 'Hatchback',
        'model': 'Hyundai i20',
        'year': 2019,
      },
    },
    {
      'id': '4',
      'name': 'Sarah Williams',
      'mobile': '6543210987',
      'vehicleNumber': 'KA 04 GH 3456',
      'status': 'approved',
      'isActive': true,
      'registeredAt': DateTime(2023, 4, 5),
      'lastActive': DateTime.now().subtract(const Duration(minutes: 15)),
      'vehicleDetails': {
        'type': 'Sedan',
        'model': 'Honda City',
        'year': 2022,
      },
    },
    {
      'id': '5',
      'name': 'Michael Brown',
      'mobile': '5432109876',
      'vehicleNumber': 'KA 05 IJ 7890',
      'status': 'approved',
      'isActive': false,
      'registeredAt': DateTime(2023, 5, 12),
      'lastActive': DateTime.now().subtract(const Duration(hours: 2)),
      'vehicleDetails': {
        'type': 'MPV',
        'model': 'Maruti Ertiga',
        'year': 2022,
      },
    },
  ];

  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredDrivers = [];
  
  @override
  void initState() {
    super.initState();
    _filteredDrivers = List.from(_drivers);
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
                driver['vehicleNumber'].toLowerCase().contains(query.toLowerCase()) ||
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: driver['isActive'] ? AppTheme.secondaryColor : Colors.grey,
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
                    _buildDetailItem('Type', driver['vehicleDetails']['type']),
                    _buildDetailItem('Model', driver['vehicleDetails']['model']),
                    _buildDetailItem('Year', driver['vehicleDetails']['year'].toString()),
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
                        // Delete driver in real implementation
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This feature will be implemented in the backend'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'All Drivers',
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterDrivers,
              decoration: InputDecoration(
                hintText: 'Search by name, vehicle number, or mobile',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _filterDrivers(''),
                      )
                    : null,
              ),
            ),
          ),
          
          // Drivers count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${_filteredDrivers.length} drivers',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_filteredDrivers.where((d) => d['isActive']).length} Online',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryTextColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_filteredDrivers.where((d) => !d['isActive']).length} Offline',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Drivers list
          Expanded(
            child: _filteredDrivers.isEmpty
                ? const Center(
                    child: Text(
                      'No drivers found',
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredDrivers.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final driver = _filteredDrivers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        child: InkWell(
                          onTap: () => _showDriverDetails(driver),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: driver['isActive']
                                      ? AppTheme.secondaryColor.withOpacity(0.1)
                                      : AppTheme.secondaryTextColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    color: driver['isActive']
                                        ? AppTheme.secondaryColor
                                        : AppTheme.secondaryTextColor,
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
                                          color: AppTheme.secondaryTextColor,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: driver['isActive']
                                            ? AppTheme.secondaryColor
                                            : AppTheme.secondaryTextColor,
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
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatLastActive(driver['lastActive']),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
} 