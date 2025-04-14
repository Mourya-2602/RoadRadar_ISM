import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../services/api_service.dart';
import '../../models/driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _errorMessage;
  Map<String, dynamic>? _driverData;

  // Controllers for editable fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  String _selectedVehicleType = 'car';

  // List of available vehicle types
  final List<String> _vehicleTypes = ['auto', 'toto', 'car', 'bus'];

  @override
  void initState() {
    super.initState();
    _loadDriverProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _vehicleNumberController.dispose();
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

      // Initialize controllers with driver data
      setState(() {
        _driverData = response;
        _initializeControllers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load profile: ${e.toString()}';
      });
    }
  }

  void _initializeControllers() {
    _nameController.text = _driverData?['name'] ?? '';
    _mobileController.text = _driverData?['mobileNumber'] ?? '';
    _vehicleNumberController.text = _driverData?['vehicleNumber'] ?? '';
    _selectedVehicleType = _driverData?['vehicleType'] ?? 'car';
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getString('driverId');

      if (driverId == null) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Driver ID not found. Please login again.';
        });
        return;
      }

      // Prepare updated data
      final updatedData = {
        'name': _nameController.text,
        'mobileNumber': _mobileController.text,
        'vehicleNumber': _vehicleNumberController.text,
        'vehicleType': _selectedVehicleType,
      };

      // Send update to API
      final response =
          await _apiService.updateDriverProfile(driverId, updatedData);

      if (response['error'] != null) {
        setState(() {
          _isSaving = false;
          _errorMessage = response['error'];
        });
        return;
      }

      // Update local data
      await _loadDriverProfile();

      setState(() {
        _isSaving = false;
        _isEditing = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Failed to update profile: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'Driver Profile',
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _initializeControllers();
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                    children: [
                                CircleAvatar(
                                  radius: 36,
                        backgroundColor: AppTheme.primaryColor,
                                  child: Text(
                                    _driverData?['name']
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        'D',
                                    style: const TextStyle(
                          color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                      _isEditing
                                                  ? 'Edit Profile'
                                                  : _driverData?['name'] ??
                                                      'Driver',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                                              color: _driverData?['status'] ==
                                                      'approved'
                              ? AppTheme.secondaryColor
                              : AppTheme.errorColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                        ),
                        child: Text(
                                              _driverData?['status'] ==
                                                      'approved'
                                                  ? 'Verified'
                                                  : 'Pending',
                          style: const TextStyle(
                            color: Colors.white,
                                                fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _driverData?['mobileNumber'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.secondaryTextColor,
                                        ),
                      ),
                    ],
                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                const SizedBox(height: 24),

                        // Personal Information
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      const SizedBox(height: 16),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Name
                                _buildTextField(
                                  label: 'Full Name',
                                  controller: _nameController,
                                  enabled: _isEditing,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Mobile Number
                                _buildTextField(
                                  label: 'Mobile Number',
                                  controller: _mobileController,
                                  enabled: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your mobile number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Vehicle Information
                        const Text(
                          'Vehicle Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                                ),
                                const SizedBox(height: 16),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Vehicle Number
                                _buildTextField(
                                  label: 'Vehicle Number',
                                  controller: _vehicleNumberController,
                                  enabled: _isEditing,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter vehicle number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Vehicle Type Dropdown
                                _isEditing
                                    ? DropdownButtonFormField<String>(
                                        value: _selectedVehicleType,
                                        decoration: const InputDecoration(
                                          labelText: 'Vehicle Type',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: _vehicleTypes.map((String type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(
                                              type
                                                      .substring(0, 1)
                                                      .toUpperCase() +
                                                  type.substring(1),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              _selectedVehicleType = newValue;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select a vehicle type';
                                          }
                                          return null;
                                        },
                                      )
                                    : _buildTextField(
                                        label: 'Vehicle Type',
                                        controller: TextEditingController(
                                          text: _selectedVehicleType
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              _selectedVehicleType.substring(1),
                                        ),
                                        enabled: false,
                                      ),
                              ],
                            ),
                          ),
                        ),

                        // Save/Cancel Buttons for edit mode
                        if (_isEditing) ...[
                          const SizedBox(height: 24),
                          Row(
                              children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isSaving
                                      ? null
                                      : () {
                                          setState(() {
                                            _isEditing = false;
                                            _initializeControllers();
                                          });
                                        },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    side: const BorderSide(
                                        color: AppTheme.primaryColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: AppTheme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Save'),
                                ),
                                ),
                              ],
                            ),
                    ],
                      ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(
        color: enabled ? AppTheme.textColor : AppTheme.secondaryTextColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: !enabled,
        fillColor: enabled ? Colors.transparent : Colors.grey[100],
      ),
    );
  }
}
