import 'package:flutter/material.dart';
import 'pages/admin.dart';
import 'pages/driver.dart';
import 'pages/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: Text("                Road Radar     "),
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: Icon(Icons.menu),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()),);
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 130,
                  ),
                ),
              ),
              GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Driver()),);
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.directions_bike_rounded,
                    color: Colors.white,
                    size: 110,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20), // Space between rows
          Padding(
            padding: EdgeInsets.only(left: 20),
            // User Container with Navigation
            child:
            GestureDetector(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => User()),);
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(25),
                child: Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
