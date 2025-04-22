import 'package:flutter/material.dart';
import './profile/userdetails.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color.fromARGB(255, 99, 203, 222),
                    backgroundImage: AssetImage("assets/images/user1.png"),
                  ),
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
                    subtitle: "Raja",
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 10),
                  ProfileInfoCard(
                    icon: Icons.email,
                    title: "Email",
                    subtitle: "raja@example.com",
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 10),
                  ProfileInfoCard(
                    icon: Icons.phone,
                    title: "Phone",
                    subtitle: "+1 123 456 7890",
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 10),
                  ProfileInfoCard(
                    icon: Icons.location_city,
                    title: "Address",
                    subtitle: "123 Street, City, Country",
                    onEdit: () {
                      // Navigate to edit screen or show dialog
                    },
                  ),
                  SizedBox(height: 20),

                  // New card to navigate to User Details screen
                  ProfileInfoCard(
                    icon: Icons.info,
                    title: "View Full Details",
                    subtitle: "Tap to see all user details",
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailsScreen()),
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
                  SettingsCard(
                    icon: Icons.lock,
                    iconColor: Colors.red,
                    backgroundColor: Colors.pink,
                    title: "Change Password",
                    onTap: () {
                      // Navigate to Change Password screen
                    },
                  ),
                  SizedBox(height: 10),
                  SettingsCard(
                    icon: Icons.notifications,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.lightBlue,
                    title: "Notification Settings",
                    onTap: () {
                      // Navigate to Notification Settings screen
                    },
                  ),
                  SizedBox(height: 10),
                  SettingsCard(
                    icon: Icons.privacy_tip,
                    iconColor: Colors.green,
                    backgroundColor: Colors.lightGreen,
                    title: "Privacy Settings",
                    onTap: () {
                      // Navigate to Privacy Settings screen
                    },
                  ),
                  SizedBox(height: 10),
                  SettingsCard(
                    icon: Icons.language,
                    iconColor: Colors.orange,
                    backgroundColor: Colors.deepOrange,
                    title: "Language",
                    onTap: () {
                      // Navigate to Language Settings screen
                    },
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
          // Replace edit icon with arrow icon and add swipe gesture
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! < 0) {
                // Left swipe detected
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Left swipe to check')),
                );
              }
            },
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: onEdit,
            ),
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
