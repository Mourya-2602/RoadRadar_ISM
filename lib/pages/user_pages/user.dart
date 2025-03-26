import 'package:flutter/material.dart';
import 'user_homepage.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    // String password = _passwordController.text;

    if (username == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter your name")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome $username")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserHomePage()),);
    }

  }

  @override
  void dispose() {
    _usernameController.dispose();
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
                  labelText: 'Name',
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
              child: Text('Login',style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
