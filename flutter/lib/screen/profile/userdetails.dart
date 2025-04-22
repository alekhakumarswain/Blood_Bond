import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    String jsonString = await rootBundle.loadString('assets/Data/profile.json');
    setState(() {
      profileData = json.decode(jsonString);
    });
  }

  Widget buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF085D2D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Color(0xFF085D2D), size: 24),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF085D2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListInfoCard(String title, List<dynamic> values) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              values.isEmpty ? "None" : values.join(", "),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMedicalItemCard(
      Map<String, dynamic> item, String type, Function onDelete) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['name'] ??
                        item['doctorName'] ??
                        item['testType'] ??
                        '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF085D2D),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(),
                ),
              ],
            ),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 8),
            if (type == 'medicine') ...[
              buildInfoRow("Dosage", item['dosage'] ?? ''),
              buildInfoRow("Category", item['category'] ?? ''),
              buildInfoRow("Quantity", item['quantity']?.toString() ?? ''),
              buildInfoRow("Store", item['store']?['storeName'] ?? ''),
              buildInfoRow("Purchase Date", item['purchaseDate'] ?? ''),
              buildInfoRow("Next Refill", item['nextRefillDate'] ?? ''),
            ] else if (type == 'appointment') ...[
              buildInfoRow("Specialty", item['specialty'] ?? ''),
              buildInfoRow("Hospital", item['hospitalName'] ?? ''),
              buildInfoRow("Date", item['appointmentDate'] ?? ''),
              buildInfoRow("Time", item['appointmentTime'] ?? ''),
              buildInfoRow("Type", item['appointmentType'] ?? ''),
              buildInfoRow("Status", item['status'] ?? ''),
              if (item['virtualMeetingUrl'] != null)
                buildInfoRow("Meeting Link", item['virtualMeetingUrl'] ?? ''),
            ] else if (type == 'bloodTest') ...[
              buildInfoRow("Date", item['testDate'] ?? ''),
              buildInfoRow("Time", item['testTime'] ?? ''),
              buildInfoRow("Lab", item['pathologyLab']?['labName'] ?? ''),
              buildInfoRow("Status", item['status'] ?? ''),
              buildInfoRow("Price", "₹${item['price']?.toString() ?? ''}"),
              if (item['resultsAvailable'] == true) ...[
                SizedBox(height: 8),
                Text(
                  "Test Results:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF085D2D),
                  ),
                ),
                ...(item['results'] as Map<String, dynamic>?)?.entries.map((e) {
                      return buildInfoRow(e.key, e.value.toString());
                    })?.toList() ??
                    [],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("My Health Profile"),
          backgroundColor: Color(0xFF085D2D),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF085D2D)),
          ),
        ),
      );
    }

    final personalInfo = profileData!['personalInformation'] ?? {};
    final healthMetrics = profileData!['healthMetrics'] ?? {};
    final medicalHistory = profileData!['medicalHistory'] ?? {};
    final medications = profileData!['medications'] ?? {};
    final lifestyleFactors = profileData!['lifestyleFactors'] ?? {};
    final medicinePurchases = profileData!['medicinePurchases'] ?? [];
    final appointments = profileData!['appointments'] ?? [];
    final bloodTests = profileData!['bloodTests'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("My Health Profile"),
        backgroundColor: Color(0xFF085D2D),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information Section
            buildSectionTitle("Personal Information", Icons.person),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInfoCard("Name", personalInfo['name'] ?? ''),
                buildInfoCard("Blood Type", personalInfo['bloodType'] ?? ''),
                buildInfoCard("Gender", personalInfo['gender'] ?? ''),
                buildInfoCard(
                    "DOB", personalInfo['dob']?.toString().split('T')[0] ?? ''),
                buildInfoCard("Phone", personalInfo['phone'] ?? ''),
                buildInfoCard("Emergency Contact",
                    personalInfo['emergencyContact']?['name'] ?? ''),
              ],
            ),

            // Health Metrics Section
            buildSectionTitle("Health Metrics", Icons.monitor_heart),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInfoCard(
                    "Blood Pressure", healthMetrics['bloodPressure'] ?? ''),
                buildInfoCard("Weight",
                    "${healthMetrics['weight']?.toString() ?? ''} kg"),
                buildInfoCard("Height",
                    "${healthMetrics['height']?.toString() ?? ''} cm"),
                buildInfoCard(
                    "BMI",
                    (healthMetrics['weight'] != null &&
                            healthMetrics['height'] != null)
                        ? ((healthMetrics['weight'] /
                                ((healthMetrics['height'] / 100) *
                                    (healthMetrics['height'] / 100)))
                            .toStringAsFixed(1))
                        : ''),
              ],
            ),

            // Medical History Section
            buildSectionTitle("Medical History", Icons.medical_services),
            buildListInfoCard("Chronic Conditions",
                medicalHistory['chronicConditions'] ?? []),
            buildListInfoCard(
                "Family History", medicalHistory['familyHistory'] ?? []),
            buildInfoCard(
                "Surgeries", medicalHistory['surgeries']?.toString() ?? 'No'),
            buildInfoCard("Allergies",
                medicalHistory['otherAllergies']?.toString() ?? 'None'),

            // Lifestyle Section
            buildSectionTitle("Lifestyle", Icons.fitness_center),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInfoCard(
                    "Smoking", lifestyleFactors['smokingStatus'] ?? ''),
                buildInfoCard(
                    "Alcohol", lifestyleFactors['alcoholConsumption'] ?? ''),
                buildInfoCard(
                    "Exercise", lifestyleFactors['exerciseFrequency'] ?? ''),
                buildInfoCard("Sleep",
                    "${lifestyleFactors['sleepHours']?.toString() ?? ''} hours"),
              ],
            ),

            // Medications Section
            buildSectionTitle("Current Medications", Icons.medication),
            if (medications['currentMeds'] == true &&
                medications['medsList'] != null &&
                medications['medsList'].isNotEmpty)
              ...(medications['medsList'] as List)
                  .map((med) => buildInfoCard(med, ""))
            else
              buildInfoCard("Current Medications", "None"),

            // Medicine Purchases Section
            buildSectionTitle("Medicine Purchases", Icons.local_pharmacy),
            if (medicinePurchases.isNotEmpty)
              ...medicinePurchases.map<Widget>((med) {
                return buildMedicalItemCard(med, 'medicine', () {
                  setState(() {
                    medicinePurchases.remove(med);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${med['name']} deleted'),
                      backgroundColor: Color(0xFF085D2D),
                    ),
                  );
                });
              }).toList()
            else
              buildInfoCard("No medicine purchases",
                  "You haven't purchased any medicines yet"),

            // Appointments Section
            buildSectionTitle("Appointments", Icons.calendar_today),
            if (appointments.isNotEmpty)
              ...appointments.map<Widget>((apt) {
                return buildMedicalItemCard(apt, 'appointment', () {
                  setState(() {
                    appointments.remove(apt);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Appointment deleted'),
                      backgroundColor: Color(0xFF085D2D),
                    ),
                  );
                });
              }).toList()
            else
              buildInfoCard("No appointments",
                  "You don't have any upcoming appointments"),

            // Blood Tests Section
            buildSectionTitle("Blood Tests", Icons.bloodtype),
            if (bloodTests.isNotEmpty)
              ...bloodTests.map<Widget>((test) {
                return buildMedicalItemCard(test, 'bloodTest', () {
                  setState(() {
                    bloodTests.remove(test);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Blood test deleted'),
                      backgroundColor: Color(0xFF085D2D),
                    ),
                  );
                });
              }).toList()
            else
              buildInfoCard(
                  "No blood tests", "You don't have any blood tests scheduled"),
          ],
        ),
      ),
    );
  }
}
