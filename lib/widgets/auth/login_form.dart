import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';
import '../common/custom_button.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onSubmit;
  final bool isLoading;
  final String submitButtonText;
  final String? errorText;
  final bool isEmail;

  // For driver login with vehicle number
  final bool isVehicleNumber;

  const LoginForm({
    Key? key,
    required this.onSubmit,
    this.isLoading = false,
    this.submitButtonText = 'Login',
    this.errorText,
    this.isEmail = true,
    this.isVehicleNumber = false,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _identifierController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Error text if present
          if (widget.errorText != null) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusMedium),
                border:
                    Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
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
                      widget.errorText!,
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

          // Identifier field (email or phone)
          TextFormField(
            controller: _identifierController,
            keyboardType: widget.isEmail
                ? TextInputType.emailAddress
                : (widget.isVehicleNumber
                    ? TextInputType.text
                    : TextInputType.phone),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: widget.isEmail
                  ? 'Email'
                  : (widget.isVehicleNumber
                      ? 'Vehicle Number'
                      : 'Mobile Number'),
              prefixIcon: Icon(
                widget.isEmail
                    ? Icons.email_outlined
                    : (widget.isVehicleNumber
                        ? Icons.directions_car_outlined
                        : Icons.phone_android_outlined),
                color: AppTheme.primaryColor,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.isEmail
                    ? 'Please enter your email'
                    : (widget.isVehicleNumber
                        ? 'Please enter your vehicle number'
                        : 'Please enter your mobile number');
              }

              if (widget.isEmail && !_isValidEmail(value)) {
                return 'Please enter a valid email address';
              }

              if (!widget.isEmail &&
                  !widget.isVehicleNumber &&
                  !_isValidPhone(value)) {
                return 'Please enter a valid mobile number';
              }

              return null;
            },
            inputFormatters: widget.isVehicleNumber
                ? [
                    // Allow only uppercase letters and numbers for vehicle numbers
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ]
                : (widget.isEmail
                    ? null
                    : [
                        // Allow only numbers for phone
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ]),
          ),
          const SizedBox(height: AppTheme.spacingMedium),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppTheme.primaryColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppTheme.neutralColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingLarge),

          // Submit button
          CustomButton(
            text: widget.submitButtonText,
            onPressed: _submit,
            isLoading: widget.isLoading,
            fullWidth: true,
            size: ButtonSize.large,
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\d{10}$').hasMatch(phone);
  }
}
