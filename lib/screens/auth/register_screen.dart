import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';

enum RegisterUserType { user, driver }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  RegisterUserType _userType = RegisterUserType.user;
  bool _isLoading = false;
  String? _errorText;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  // Handle registration
  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      if (_userType == RegisterUserType.user) {
        // Register user
        // final user = await AuthService.registerUser(
        //   _nameController.text.trim(),
        //   _emailController.text.trim(),
        //   _mobileController.text.trim(),
        //   _passwordController.text,
        // );

        // Placeholder for registration
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.userHome);
        }
      } else {
        // Register driver
        // final driver = await AuthService.registerDriver(
        //   _nameController.text.trim(),
        //   _emailController.text.trim(),
        //   _mobileController.text.trim(),
        //   _vehicleNumberController.text.trim(),
        //   _passwordController.text,
        //   // Additional vehicle details would be needed here
        // );

        // Placeholder for registration
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.driverHome);
        }
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
      appBar: const CustomAppBar(
        title: 'Create Account',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error message if any
              if (_errorText != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusMedium),
                    border: Border.all(
                        color: AppTheme.accentColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.accentColor,
                        size: 18,
                      ),
                      const SizedBox(width: AppTheme.spacingSmall),
                      Expanded(
                        child: Text(
                          _errorText!,
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
              ],

              // Registration type selector
              const Text(
                'Register as:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _userType = RegisterUserType.user;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _userType == RegisterUserType.user
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : null,
                        foregroundColor: _userType == RegisterUserType.user
                            ? AppTheme.primaryColor
                            : AppTheme.secondaryTextColor,
                        side: BorderSide(
                          color: _userType == RegisterUserType.user
                              ? AppTheme.primaryColor
                              : AppTheme.dividerColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingMedium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 18,
                            color: _userType == RegisterUserType.user
                                ? AppTheme.primaryColor
                                : AppTheme.secondaryTextColor,
                          ),
                          const SizedBox(width: AppTheme.spacingSmall),
                          const Text('User'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _userType = RegisterUserType.driver;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _userType == RegisterUserType.driver
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : null,
                        foregroundColor: _userType == RegisterUserType.driver
                            ? AppTheme.primaryColor
                            : AppTheme.secondaryTextColor,
                        side: BorderSide(
                          color: _userType == RegisterUserType.driver
                              ? AppTheme.primaryColor
                              : AppTheme.dividerColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingMedium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.drive_eta_outlined,
                            size: 18,
                            color: _userType == RegisterUserType.driver
                                ? AppTheme.primaryColor
                                : AppTheme.secondaryTextColor,
                          ),
                          const SizedBox(width: AppTheme.spacingSmall),
                          const Text('Driver'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              // Registration form fields
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Mobile field
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone_android_outlined),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Vehicle number field (only for drivers)
              if (_userType == RegisterUserType.driver) ...[
                TextFormField(
                  controller: _vehicleNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Number',
                    prefixIcon: Icon(Icons.directions_car_outlined),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your vehicle number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingMedium),
              ],

              // Password section
              const Text(
                'Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Confirm password field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingXLarge),

              // Terms and conditions checkbox
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the Terms and Conditions and Privacy Policy',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              // Register button
              CustomButton(
                text: 'Create Account',
                onPressed: _register,
                isLoading: _isLoading,
                fullWidth: true,
                size: ButtonSize.large,
              ),
              const SizedBox(height: AppTheme.spacingMedium),

              // Login link
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
