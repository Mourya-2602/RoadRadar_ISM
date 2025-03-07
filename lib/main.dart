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
      backgroundColor: Color(0xfff0eee5),
      appBar: AppBar(
        title: Text("Road Radar Login", style: TextStyle(fontFamily: 'Raleway',fontWeight: FontWeight.bold),),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xffb05730),
        elevation: 0,
        // leading: Icon(Icons.menu),
      ),

      // drawer: Drawer(
      //   backgroundColor: Color(0xffb05730),
      // ),

      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => User()),);
                  },
                  child: Container(
                    height: 150,
                    // width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xffb05730),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 64,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text(
                                // selectionColor: Colors.white,
                                "User Login",
                                softWrap: true,
                                style: TextStyle(
                                  // fontFamily: ,
                                  fontFamily: 'Raleway',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.3,

                              child: Text(

                                "Use your admission number.",
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,

                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.navigate_next, color: Colors.white, size: 32,)
                      ],
                    ),
                  ),
                ),
                GestureDetector(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Driver()),);
                  },
                  child: Container(
                    height: 150,
                    // width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xffb05730),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.drive_eta,
                          color: Colors.white,
                          size: 64,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text(
                                // selectionColor: Colors.white,
                                "Driver Login",
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text(
                                "Use your vehicle registration number and mobile number",
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,

                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.navigate_next, color: Colors.white, size: 32,)
                      ],
                    ),
                  ),
                ),
        
                GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()),);
                },
                  child: Container(
                    height: 150,
                    // width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xffb05730),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(25),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                          size: 64,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text(
                                // selectionColor: Colors.white,
                                "Admin Login",
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text(
                                "Use your ADMIN PIN",
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,

                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.navigate_next, color: Colors.white, size: 32,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
        
        
        
          ],
        ),
      ),
    );
  }
}
