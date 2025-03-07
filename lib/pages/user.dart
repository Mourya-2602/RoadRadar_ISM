import 'package:flutter/material.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0eee5),
      appBar: AppBar(
        title: Text("User Login",
          style: TextStyle(fontFamily: 'Raleway',fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xffb05730),
        elevation: 0,
        // leading: Icon(Icons.menu),
      ),

    );
  }
}
