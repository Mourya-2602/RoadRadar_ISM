import 'package:flutter/material.dart';
import 'pages/all_logins.dart'; // Make sure the file path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginButtonPage(),
    );
  }
}

class LoginButtonPage extends StatelessWidget {
  const LoginButtonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0eee5),
      appBar: AppBar(
        title: const Text(
          "Main Page",
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffb05730),
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffb05730),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllLogins()),
            );
          },
          child: const Text(
            "Login",
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
