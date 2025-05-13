import 'package:blood_bond/screen/Doctor.dart';
import 'package:blood_bond/screen/Medicine.dart';
import 'package:blood_bond/screen/Profile.dart';
import 'package:blood_bond/screen/BloodTestPage.dart';
import 'package:blood_bond/screen/BloodDonateReceivePage.dart';
import 'package:blood_bond/screen/Ai.dart';
import 'package:blood_bond/screen/mentalHealth.dart';
import 'package:blood_bond/screen/Healthmonitor.dart';
import 'package:blood_bond/screen/profile/userdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_update.dart'; // Import ProfileUpdateScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'User'; // Default name

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
    });
  }

  List DoctorImg = [
    "doctor1.jpg",
    "doctor2.jpg",
    "doctor3.jpg",
    "doctor4.jpg",
  ];
  List DoctorName = [
    "Dr. A K Swain",
    "Dr. P K Swain",
    "Dr. K Ray",
    "Dr. R K Pani"
  ];
  List DoctorSpecialization = [
    "Cardiologist",
    "Dermatologist",
    "Opthalmologist",
    "Medicine Specialist",
  ];
  List DoctorRating = ["4.3", "4.5", "4.9", "4.8"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Blood Bond"),
          centerTitle: true,
          backgroundColor: Color(0xFFBE179A),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello 🖐️",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color.fromARGB(255, 151, 210, 250),
                      backgroundImage: AssetImage("assets/images/user2.png"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BloodTestPage()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 39, 122, 247),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 4,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.science_outlined,
                              color: Color(0xFF44F490),
                              size: 35,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Blood Test",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Book an Appointment",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AIScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Color(0xFF085D2D),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 4,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_search_outlined,
                              color: Color(0xFFEA65CD),
                              size: 35,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Virtual Doctor",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Book an Appointment",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BloodDonateReceivePage()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(17),
                      decoration: BoxDecoration(
                          color: Color(0xFF085D2D),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 4,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bloodtype,
                              color: Color(0xFFEA65CD),
                              size: 35,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Donate Blood",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Check Blood Availability",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicineScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(17),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 39, 122, 247),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 4,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.medical_services_rounded,
                              color: Color(0xFF44F490),
                              size: 35,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Medicine",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Order online Medicine",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Popular Doctors",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: Colors.black38,
                  ),
                ),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: DoctorImg.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 2, 62, 48),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(66, 8, 161, 167),
                            blurRadius: 5,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                AssetImage("assets/images/${DoctorImg[index]}"),
                          ),
                          Text(
                            "${DoctorName[index]}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(221, 186, 201, 17),
                            ),
                          ),
                          Text(
                            "${DoctorSpecialization[index]}",
                            style: TextStyle(
                              color: Colors.blue[400],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                              ),
                              Text(
                                "${DoctorRating[index]}",
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(115, 225, 240, 195),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              SectionCard(
                icon: Icons.bloodtype,
                iconColor: Colors.red,
                backgroundColor: Colors.pink,
                title: "Blood Donation",
                subtitle: "Donate or Request Blood",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BloodDonateReceivePage()));
                },
              ),
              SizedBox(height: 20),
              SectionCard(
                icon: Icons.medical_services,
                iconColor: Colors.blue,
                backgroundColor: Colors.lightBlue,
                title: "Blood Testing",
                subtitle: "Book a Blood Test",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BloodTestPage()));
                },
              ),
              SizedBox(height: 20),
              SectionCard(
                icon: Icons.local_hospital,
                iconColor: Colors.green,
                backgroundColor: Colors.lightGreen,
                title: "Doctor Consultation",
                subtitle: "Consult with Doctors",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorScreen()));
                },
              ),
              SizedBox(height: 20),
              SectionCard(
                icon: Icons.folder,
                iconColor: Colors.orange,
                backgroundColor: Colors.deepOrange,
                title: "Health Records",
                subtitle: "Please update your profile first",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserDetailsScreen()));
                },
              ),
              SizedBox(height: 20),
              SectionCard(
                icon: Icons.fitness_center,
                iconColor: Colors.purple,
                backgroundColor: Colors.deepPurple,
                title: "Health Monitoring",
                subtitle: "Track Your Health",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HealthMonitor()));
                },
              ),
              SizedBox(height: 20),
              SectionCard(
                icon: Icons.psychology,
                iconColor: Colors.brown,
                backgroundColor: const Color.fromARGB(255, 235, 133, 31),
                title: "Mental Health",
                subtitle: "Access Mental Health Support",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MentalHealthDashboard()));
                },
              ),
              SizedBox(height: 20),
              SectionCard(
                icon: Icons.person,
                iconColor: Colors.teal,
                backgroundColor: const Color.fromARGB(255, 98, 127, 242),
                title: "Profile",
                subtitle: "View and Edit Profile",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final Function() onTap;

  SectionCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 4,
            )
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
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
