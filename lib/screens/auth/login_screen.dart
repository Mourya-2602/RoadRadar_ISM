import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/auth/login_form.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../services/auth_service.dart';
import '../../config/routes.dart';

// Driver login option enum
enum DriverLoginOption { mobile, vehicle }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _errorText;
  DriverLoginOption _driverLoginOption = DriverLoginOption.mobile;

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

  // Handle user login
  Future<void> _loginUser(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final user = await Future.delayed(
        const Duration(seconds: 1),
        () => null, // Replace with AuthService.loginUser(email, password)
      );

      if (user != null) {
        // Navigate to user home on successful login
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.userHome);
        }
      } else {
        setState(() {
          _errorText = 'Invalid email or password';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoading = false;
      });
    }
  }

  // Handle driver login with mobile
  Future<void> _loginDriverWithMobile(String mobile, String password) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final driver = await Future.delayed(
        const Duration(seconds: 1),
        () =>
            null, // Replace with AuthService.loginDriverWithMobile(mobile, password)
      );

      if (driver != null) {
        // Navigate to driver home on successful login
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
        }
      } else {
        setState(() {
          _errorText = 'Invalid mobile number or password';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoading = false;
      });
    }
  }

  // Handle driver login with vehicle number
  Future<void> _loginDriverWithVehicle(
      String vehicleNumber, String password) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final driver = await Future.delayed(
        const Duration(seconds: 1),
        () =>
            null, // Replace with AuthService.loginDriverWithVehicle(vehicleNumber, password)
      );

      if (driver != null) {
        // Navigate to driver home on successful login
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
        }
      } else {
        setState(() {
          _errorText = 'Invalid vehicle number or password';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoading = false;
      });
    }
  }

  // Handle admin login
  Future<void> _loginAdmin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final admin = await Future.delayed(
        const Duration(seconds: 1),
        () => null, // Replace with AuthService.loginAdmin(email, password)
      );

      if (admin != null) {
        // Navigate to admin home on successful login
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
        }
      } else {
        setState(() {
          _errorText = 'Invalid admin credentials';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header and logo
            Container(
              color: AppTheme.primaryColor,
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingLarge),
                  // App logo
                  const Icon(
                    Icons.location_on,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  // App name
                  const Text(
                    'Road Radar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSmall),
                  // Tagline
                  Text(
                    'Navigate with Confidence',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  // Tab bar for user types
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusMedium),
                        color: Colors.white,
                      ),
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: Colors.white,
                      tabs: const [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline, size: 16),
                              SizedBox(width: 8),
                              Text('User'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.drive_eta_outlined, size: 16),
                              SizedBox(width: 8),
                              Text('Driver'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.admin_panel_settings_outlined,
                                  size: 16),
                              SizedBox(width: 8),
                              Text('Admin'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Login forms
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // User login
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'User Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        const Text(
                          'Log in to track vehicles in real-time',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                        LoginForm(
                          onSubmit: _loginUser,
                          isLoading: _isLoading,
                          errorText: _errorText,
                          submitButtonText: 'Login as User',
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                        // Register link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child:
                                const Text('Don\'t have an account? Register'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Driver login
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Driver Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        const Text(
                          'Log in as a driver to share your location',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        // Driver login options
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _driverLoginOption =
                                        DriverLoginOption.mobile;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _driverLoginOption ==
                                          DriverLoginOption.mobile
                                      ? AppTheme.primaryColor.withOpacity(0.1)
                                      : null,
                                  foregroundColor: _driverLoginOption ==
                                          DriverLoginOption.mobile
                                      ? AppTheme.primaryColor
                                      : AppTheme.secondaryTextColor,
                                  side: BorderSide(
                                    color: _driverLoginOption ==
                                            DriverLoginOption.mobile
                                        ? AppTheme.primaryColor
                                        : AppTheme.dividerColor,
                                  ),
                                ),
                                child: const Text('Mobile'),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingSmall),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _driverLoginOption =
                                        DriverLoginOption.vehicle;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _driverLoginOption ==
                                          DriverLoginOption.vehicle
                                      ? AppTheme.primaryColor.withOpacity(0.1)
                                      : null,
                                  foregroundColor: _driverLoginOption ==
                                          DriverLoginOption.vehicle
                                      ? AppTheme.primaryColor
                                      : AppTheme.secondaryTextColor,
                                  side: BorderSide(
                                    color: _driverLoginOption ==
                                            DriverLoginOption.vehicle
                                        ? AppTheme.primaryColor
                                        : AppTheme.dividerColor,
                                  ),
                                ),
                                child: const Text('Vehicle'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                        // Driver login form based on selection
                        if (_driverLoginOption == DriverLoginOption.mobile)
                          LoginForm(
                            onSubmit: _loginDriverWithMobile,
                            isLoading: _isLoading,
                            errorText: _errorText,
                            isEmail: false,
                            submitButtonText: 'Login as Driver',
                          )
                        else
                          LoginForm(
                            onSubmit: _loginDriverWithVehicle,
                            isLoading: _isLoading,
                            errorText: _errorText,
                            isEmail: false,
                            isVehicleNumber: true,
                            submitButtonText: 'Login as Driver',
                          ),
                        const SizedBox(height: AppTheme.spacingLarge),
                        // Register link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child:
                                const Text('Don\'t have an account? Register'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Admin login
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Admin Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        const Text(
                          'Log in to manage drivers and system settings',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingLarge),
                        LoginForm(
                          onSubmit: _loginAdmin,
                          isLoading: _isLoading,
                          errorText: _errorText,
                          submitButtonText: 'Login as Admin',
                        ),
                      ],
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
