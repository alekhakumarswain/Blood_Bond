import 'package:blood_bond/screen/Medicine.dart';
import 'package:blood_bond/screen/Profile.dart';
import 'package:blood_bond/screen/BloodTestPage.dart';
import 'package:blood_bond/screen/BloodDonateReceivePage.dart';
import 'package:blood_bond/screen/Ai.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  List symptoms = [
    "Temperature",
    "Snuffle",
    "Fever",
    "Cough",
    "Cold",
  ];
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Blood Bond"),
        centerTitle: true,
        backgroundColor:
            Color(0xFFBE179A), // Match the color with BloodTestPage
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
                    "Hello Raja",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color.fromARGB(255, 151, 210, 250),
                    backgroundImage: AssetImage("assets/images/user1.png"),
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
                            builder: (context) => MedicineScreen()));
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
                "What Are your Symptoms?",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 7,
                            spreadRadius: 5,
                          )
                        ]),
                    child: Center(
                      child: Text(
                        symptoms[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Popular  Doctors",
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
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 125, 230),
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
                                color: const Color.fromARGB(115, 225, 240, 195),
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
              title: "Online Consultation",
              subtitle: "Consult with Doctors",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MedicineScreen()));
              },
            ),
            SizedBox(height: 20),
            SectionCard(
              icon: Icons.folder,
              iconColor: Colors.orange,
              backgroundColor: Colors.deepOrange,
              title: "Health Records",
              subtitle: "Manage Your Health Records",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
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
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
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
