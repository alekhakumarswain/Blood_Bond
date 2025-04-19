import 'package:blood_bond/screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:blood_bond/screen/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome', // Start with WelcomeScreen
      routes: {
        '/welcome': (context) => WelcomeScreen(), // Route for WelcomeScreen
        '/home': (context) => HomeScreen(), // Route for HomeScreen
        // Add other routes as needed (e.g., '/bloodtest' for BloodTestPage)
      },
    );
  }
}
