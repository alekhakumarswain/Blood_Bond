import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './profile/userdetails.dart';
import 'welcome.dart'; // Import WelcomeScreen for navigation after sign-out

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late FirebaseDatabase _database;
  Map<String, dynamic>? personalInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance;
    fetchUserData();
  }

  String getSafePath(String phone) {
    return phone.replaceAll(RegExp(r'[.#$/[\]]'), '_');
  }

  Future<void> fetchUserData() async {
    try {
      // Assuming the phone number is stored or retrieved from Firebase Auth
      final userPhone =
          FirebaseAuth.instance.currentUser?.phoneNumber ?? '918018226416';
      final safePhone = '918018226416'; // getSafePath(userPhone);
      final snapshot = await _database
          .ref()
          .child('users/$safePhone/personalInformation')
          .get();

      if (snapshot.exists) {
        setState(() {
          personalInfo = Map<String, dynamic>.from(snapshot.value as Map);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not found')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

  // Function to handle sign-out
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Color(0xFF085D2D),
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF085D2D)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFF085D2D),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Profile",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Removed CircleAvatar (Profile Photo)
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.black26,
                    ),
                  ),
                  SizedBox(height: 15),
                  ProfileInfoCard(
                    icon: Icons.person,
                    title: "Name",
                    subtitle: personalInfo?['name'] ?? 'Raja',
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 10),
                  ProfileInfoCard(
                    icon: Icons.email,
                    title: "Email",
                    subtitle: personalInfo?['email'] ?? 'raja@example.com',
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 10),
                  ProfileInfoCard(
                    icon: Icons.phone,
                    title: "Phone",
                    subtitle: personalInfo?['phone'] ?? '+1 123 456 7890',
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 10),
                  ProfileInfoCard(
                    icon: Icons.location_city,
                    title: "Address",
                    subtitle:
                        personalInfo?['address'] ?? '123 Street, City, Country',
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 10),
                  ProfileInfoCard(
                    icon: Icons.person_outline,
                    title: "View More Details",
                    subtitle: "Tap to see all details about you",
                    onEdit: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Account Settings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.black26,
                    ),
                  ),
                  SizedBox(height: 15),
                  // Removed Change Password, Notification Settings, and Privacy Settings

                  SizedBox(height: 10),
                  SettingsCard(
                    icon: Icons.logout,
                    iconColor: Colors.redAccent,
                    backgroundColor: Colors.red,
                    title: "Sign Out",
                    onTap: () => _signOut(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Function() onEdit;

  ProfileInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.black54,
              size: 35,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final Function() onTap;

  SettingsCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(31, 54, 45, 45),
              blurRadius: 16,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 35,
              ),
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
