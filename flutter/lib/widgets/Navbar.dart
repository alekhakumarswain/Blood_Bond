import 'package:blood_bond/screen/Medicine.dart' as medicine;
import 'package:flutter/material.dart';
import 'package:blood_bond/screen/Doctor.dart' as doctor;
import 'package:blood_bond/screen/Ai.dart' as ai;
import 'package:blood_bond/screen/BloodTestPage.dart' as test;
import 'package:blood_bond/screen/BloodDonateReceivePage.dart' as donate;
import 'package:blood_bond/screen/Home.dart'; // Import HomeScreen

class NavScreen extends StatefulWidget {
  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0; // Default to HomeScreen at index 0

  final _screens = <Widget>[
    HomeScreen(), // Default home screen (not in navbar)
    donate.BloodDonateReceivePage(),
    test.BloodTestPage(),
    ai.AIScreen(), // AI chat screen (SuuSri)
    medicine.MedicineScreen(),
    doctor.DoctorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: _selectedIndex ==
              3 // Hide navbar only for AIScreen (index 3)
          ? null // Set to null to hide the navbar
          : DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Container(
                height: 115,
                padding: EdgeInsets.only(top: 5),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Color(0xff7165d6),
                  unselectedItemColor: Color(0x3C6754D2),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  iconSize: 25,
                  currentIndex: _selectedIndex > 0
                      ? _selectedIndex - 1
                      : 0, // Adjusted for navbar
                  onTap: (index) {
                    setState(() {
                      _selectedIndex =
                          index + 1; // Map navbar index to _screens index (1-5)
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
                      icon: Transform.translate(
                        offset: Offset(0, 0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _selectedIndex == 3
                                ? Color(0xff7165d6)
                                : Color(0x3C6754D2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.assistant,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
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
              ),
            ),
    );
  }
}
