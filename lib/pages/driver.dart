import 'package:flutter/material.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: const Text('contact admin for your credentials'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Color(0xffb05730))),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    String registration = _registrationController.text;
    String mobile = _mobileController.text;

    // For demonstration, assume valid credentials are:
    // Vehicle Registration: "ABC123" and Mobile Number: "9876543210"
    if (registration == "ABC123" && mobile == "9876543210") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successful")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
    }
  }

  @override
  void dispose() {
    _registrationController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0eee5),
      appBar: AppBar(
        title: const Text(
          "Driver Login",
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffb05730),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Vehicle Registration input field
            SizedBox(
              width: 350,
              child: TextField(
                controller: _registrationController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Registration',
                  labelStyle: const TextStyle(color: Color(0xffb05730)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffb05730)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffb05730)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Mobile Number input field
            SizedBox(
              width: 350,
              child: TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: const TextStyle(color: Color(0xffb05730)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffb05730)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffb05730)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Forgot Password link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xffb05730)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffb05730), // Button background color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
