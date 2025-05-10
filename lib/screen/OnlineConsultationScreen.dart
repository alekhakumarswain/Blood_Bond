import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String image;
  final String name;
  final String specialization;
  final String rating;
  final String availability;
  final Function() onTap;

  DoctorCard({
    required this.image,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.availability,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 45,
          backgroundImage: AssetImage("images/$image"),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              specialization,
              style: TextStyle(color: const Color.fromARGB(255, 2, 67, 120)),
            ),
            SizedBox(height: 1),
            Text(
              availability,
              style: TextStyle(color: Color.fromARGB(255, 192, 32, 72)),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 100, // Ensure the trailing column has a fixed width
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Text(rating, style: TextStyle(color: Colors.black45)),
                ],
              ),
              SizedBox(height: 5), // Adjust spacing between rating and button
              ElevatedButton(
                onPressed: onTap,
                child: Text("Consult"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8), // Reduced padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Reduced corner radius
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorDetailBottomSheet extends StatelessWidget {
  final String doctorName;
  final String specialization;

  DoctorDetailBottomSheet({
    required this.doctorName,
    required this.specialization,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      // Use MediaQuery to set height dynamically
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        // Allow scrolling if content is too long
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              specialization,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              "About the Doctor",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Text(
              "Dr. $doctorName is a highly experienced $specialization. "
              "They are known for their expertise in providing the best consultation.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Schedule consultation
                },
                child: Text("Schedule Consultation"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Color.fromARGB(255, 40, 254, 47),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
