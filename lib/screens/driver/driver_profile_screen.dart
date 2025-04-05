import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  // Mock data - in real app, get from Firebase
  final Map<String, dynamic> _driverData = {
    'name': 'John Doe',
    'mobile': '9876543210',
    'vehicleNumber': 'KA 01 AB 1234',
    'status': 'approved',
    'registeredAt': DateTime(2023, 1, 15),
    'lastLogin': DateTime.now().subtract(const Duration(hours: 5)),
    'vehicleDetails': {
      'type': 'Sedan',
      'model': 'Toyota Corolla',
      'year': 2020,
    }
  };

  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleYearController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _driverData['name']);
    _vehicleNumberController =
        TextEditingController(text: _driverData['vehicleNumber']);
    _vehicleTypeController =
        TextEditingController(text: _driverData['vehicleDetails']['type']);
    _vehicleModelController =
        TextEditingController(text: _driverData['vehicleDetails']['model']);
    _vehicleYearController = TextEditingController(
        text: _driverData['vehicleDetails']['year'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleNumberController.dispose();
    _vehicleTypeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // In real app, update data in Firebase
      setState(() {
        _driverData['name'] = _nameController.text;
        _driverData['vehicleNumber'] = _vehicleNumberController.text;
        _driverData['vehicleDetails']['type'] = _vehicleTypeController.text;
        _driverData['vehicleDetails']['model'] = _vehicleModelController.text;
        _driverData['vehicleDetails']['year'] =
            int.parse(_vehicleYearController.text);
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Driver Profile',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primaryColor,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isEditing
                          ? TextFormField(
                              controller: _nameController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            )
                          : Text(
                              _driverData['name'],
                              style: AppTheme.headingStyle,
                            ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _driverData['status'] == 'approved'
                              ? AppTheme.secondaryColor
                              : AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _driverData['status'] == 'approved'
                              ? 'Verified Driver'
                              : 'Pending Verification',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Profile info
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: AppTheme.subheadingStyle,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem(
                        'Mobile Number',
                        _driverData['mobile'],
                        Icons.phone,
                        editable: false,
                      ),
                      const Divider(),
                      _isEditing
                          ? TextFormField(
                              controller: _vehicleNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Vehicle Number',
                                prefixIcon: Icon(Icons.directions_car),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter vehicle number';
                                }
                                return null;
                              },
                            )
                          : _buildInfoItem(
                              'Vehicle Number',
                              _driverData['vehicleNumber'],
                              Icons.directions_car,
                            ),
                      const Divider(),
                      _buildInfoItem(
                        'Registration Date',
                        '${_driverData['registeredAt'].day}/${_driverData['registeredAt'].month}/${_driverData['registeredAt'].year}',
                        Icons.calendar_today,
                        editable: false,
                      ),
                      const Divider(),
                      _buildInfoItem(
                        'Last Login',
                        '${_driverData['lastLogin'].hour}:${_driverData['lastLogin'].minute} - ${_driverData['lastLogin'].day}/${_driverData['lastLogin'].month}/${_driverData['lastLogin'].year}',
                        Icons.access_time,
                        editable: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Vehicle details
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vehicle Information',
                        style: AppTheme.subheadingStyle,
                      ),
                      const SizedBox(height: 16),
                      _isEditing
                          ? Column(
                              children: [
                                TextFormField(
                                  controller: _vehicleTypeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Vehicle Type',
                                    prefixIcon: Icon(Icons.category),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter vehicle type';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _vehicleModelController,
                                  decoration: const InputDecoration(
                                    labelText: 'Vehicle Model',
                                    prefixIcon: Icon(Icons.directions_car),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter vehicle model';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _vehicleYearController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Manufacturing Year',
                                    prefixIcon: Icon(Icons.date_range),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter year';
                                    }
                                    try {
                                      int year = int.parse(value);
                                      if (year < 1900 ||
                                          year > DateTime.now().year) {
                                        return 'Please enter a valid year';
                                      }
                                    } catch (e) {
                                      return 'Please enter a valid year';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildInfoItem(
                                  'Vehicle Type',
                                  _driverData['vehicleDetails']['type'],
                                  Icons.category,
                                ),
                                const Divider(),
                                _buildInfoItem(
                                  'Vehicle Model',
                                  _driverData['vehicleDetails']['model'],
                                  Icons.directions_car,
                                ),
                                const Divider(),
                                _buildInfoItem(
                                  'Manufacturing Year',
                                  _driverData['vehicleDetails']['year']
                                      .toString(),
                                  Icons.date_range,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Edit/Save button
                CustomButton(
                  text: _isEditing ? 'Save Changes' : 'Edit Profile',
                  icon: _isEditing ? Icons.save : Icons.edit,
                  onPressed: _isEditing ? _saveChanges : _toggleEditMode,
                ),
                const SizedBox(height: 16),

                // Cancel button (when editing)
                if (_isEditing)
                  CustomButton(
                    text: 'Cancel',
                    isSecondary: true,
                    onPressed: _toggleEditMode,
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon,
      {bool editable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (_isEditing && editable)
            const Icon(
              Icons.edit,
              size: 18,
              color: AppTheme.secondaryTextColor,
            ),
        ],
      ),
    );
  }
}
