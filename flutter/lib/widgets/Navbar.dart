import 'package:flutter/material.dart';
import 'package:blood_bond/screen/medicine/MedicineScreen.dart';
import 'package:blood_bond/screen/Doctor.dart';
import 'package:blood_bond/screen/Ai.dart';
import 'package:blood_bond/screen/BloodTestPage.dart';
import 'package:blood_bond/screen/BloodDonateReceivePage.dart';
import 'package:blood_bond/screen/Home.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  final _screens = <Widget>[
    HomeScreen(),
    BloodDonateReceivePage(),
    BloodTestPage(),
    AIScreen(),
    MedicineScreen(),
    DoctorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _selectedIndex == 3
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex > 0 ? _selectedIndex - 1 : 0,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index + 1;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Color(0xff7165d6),
              unselectedItemColor: Colors.grey,
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
                  icon: Icon(Icons.assistant),
                  label: "SuuSri",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_pharmacy),
                  label: "Medicine",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.medical_services),
                  label: "Doctor",
                ),
              ],
            ),
    );
  }
}
