import 'package:flutter/material.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Text('contact admin for your credentials'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Color(0xffb05730))),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == "admin" && password == "1234") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0eee5),
      appBar: AppBar(
        title: Text(
          "User Login",
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xffb05730),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username input field
            SizedBox(
              width: 350,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Color(0xffb05730)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffb05730)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffb05730)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Password input field
            SizedBox(
              width: 350,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xffb05730)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffb05730)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffb05730)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            // Forgot Password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgotPasswordDialog,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xffb05730)),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffb05730), // Button background color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                // Implement your login logic here.
                _login();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
