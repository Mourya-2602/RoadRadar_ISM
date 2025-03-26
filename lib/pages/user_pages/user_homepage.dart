import 'package:flutter/material.dart';

class User_Home extends StatelessWidget {
  const User_Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xffb05730),
        elevation: 0,
      ),

    );
  }
}

