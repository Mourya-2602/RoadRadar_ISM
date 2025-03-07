import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController _pinController = TextEditingController();

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: const Text('contact Mourya/Balaji for your credentials'),
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
    String pin = _pinController.text;
    // For demonstration, assume a valid admin PIN is "0000"
    if (pin == "0000") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successful")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0eee5),
      appBar: AppBar(
        title: const Text(
          "Admin Login",
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffb05730),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Admin PIN input field wrapped in a ConstrainedBox to limit its width
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: TextField(
                  controller: _pinController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Admin PIN',
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
            ),
            const SizedBox(height: 8.0),
            // Forgot Password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgotPasswordDialog,
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xffb05730)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffb05730),
                foregroundColor: Colors.white,
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
