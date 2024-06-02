import 'package:blood_bond/screen/Medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blood_bond/screen/Home.dart';

class NavScreen extends StatefulWidget {
  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 2;
  final _screens = [
    Container(), // Blood Donation screen
    Container(), // Blood Testing screen
    HomeScreen(), // Home screen
    MedicineScreen(), // Doctor Consultation screen
    Container(), // Medicine Shop screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xff7165d6),
          unselectedItemColor: Color(0x3C6754D2),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          iconSize: 30,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.bloodtype),
              label: "Donate",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.science),
              label: "Test",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: "Medicine",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_pharmacy),
              label: "Doctor",
            ),
          ],
        ),
      ),
    );
  }
}
