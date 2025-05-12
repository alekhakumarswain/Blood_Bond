import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late FirebaseDatabase _database;
  final String _userPhone = '918018226416'; // Default mobile number
  Map<String, dynamic>? personalInfo;
  Map<String, dynamic>? healthMetrics;
  Map<String, dynamic>? medicalHistory;
  Map<String, dynamic>? lifestyleFactors;
  Map<String, dynamic>? medications;
  List<Map<String, dynamic>> medicinePurchases = [];
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> bloodTests = [];

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
      final safePhone = getSafePath(_userPhone);
      final snapshot = await _database.ref().child('users/$safePhone').get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;

        // Fetch Medicine Purchases
        final medicinePurchasesSnapshot =
            userData['medicinePurchases'] as List<dynamic>?;
        final List<Map<String, dynamic>> fetchedMedicinePurchases = [];
        if (medicinePurchasesSnapshot != null) {
          for (var i = 0; i < medicinePurchasesSnapshot.length; i++) {
            final purchase =
                Map<String, dynamic>.from(medicinePurchasesSnapshot[i] as Map);
            purchase['index'] = i;
            fetchedMedicinePurchases.add(purchase);
          }
        }

        // Fetch Appointments
        final appointmentsSnapshot = userData['appointments'] as List<dynamic>?;
        final List<Map<String, dynamic>> fetchedAppointments = [];
        if (appointmentsSnapshot != null) {
          for (var i = 0; i < appointmentsSnapshot.length; i++) {
            final appointment =
                Map<String, dynamic>.from(appointmentsSnapshot[i] as Map);
            appointment['index'] = i;
            fetchedAppointments.add(appointment);
          }
        }

        // Fetch Blood Tests
        final bloodTestsSnapshot = userData['bloodTests'] as List<dynamic>?;
        final List<Map<String, dynamic>> fetchedBloodTests = [];
        if (bloodTestsSnapshot != null) {
          for (var i = 0; i < bloodTestsSnapshot.length; i++) {
            final bloodTest =
                Map<String, dynamic>.from(bloodTestsSnapshot[i] as Map);
            if (bloodTest['pathologyLab'] != null) {
              bloodTest['pathologyLab'] =
                  Map<String, dynamic>.from(bloodTest['pathologyLab']);
            }
            if (bloodTest['results'] != null) {
              bloodTest['results'] =
                  Map<String, dynamic>.from(bloodTest['results']);
            }
            bloodTest['index'] = i;
            fetchedBloodTests.add(bloodTest);
          }
        }

        setState(() {
          personalInfo = userData['personalInformation'] != null
              ? Map<String, dynamic>.from(userData['personalInformation'])
              : {};
          healthMetrics = userData['healthMetrics'] != null
              ? Map<String, dynamic>.from(userData['healthMetrics'])
              : {};
          medicalHistory = userData['medicalHistory'] != null
              ? Map<String, dynamic>.from(userData['medicalHistory'])
              : {};
          lifestyleFactors = userData['lifestyleFactors'] != null
              ? Map<String, dynamic>.from(userData['lifestyleFactors'])
              : {};
          medications = userData['medications'] != null
              ? Map<String, dynamic>.from(userData['medications'])
              : {};
          medicinePurchases = fetchedMedicinePurchases;
          appointments = fetchedAppointments;
          bloodTests = fetchedBloodTests;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data')),
      );
    }
  }

  Widget buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF085D2D), size: 24),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(
      String title, String value, String firebasePath, String fieldKey) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      value.isEmpty ? "Not provided" : value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (firebasePath.isNotEmpty)
              IconButton(
                icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
                onPressed: () =>
                    showEditDialog(title, value, firebasePath, fieldKey, false),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildMedicalItemCard(
      Map<String, dynamic> item, String type, VoidCallback onDelete) {
    String title = '';
    String subtitle = '';
    String dateLabel = '';
    String dateValue = '';
    String sourceLabel = '';
    String? sourceValue;

    switch (type) {
      case 'medicine':
        title = item['name'] ?? 'Unknown Medicine';
        subtitle = 'Quantity: ${item['quantity'] ?? 'N/A'}';
        dateLabel = 'Purchased on';
        dateValue = item['purchaseDate']?.toString().split('T')[0] ?? 'N/A';
        sourceLabel = 'Pharmacy';
        sourceValue = item['pharmacy']?['name'] ?? 'Unknown';
        break;
      case 'appointment':
        title = item['specialty'] ?? 'Unknown Specialty';
        subtitle = 'With ${item['doctor']?['name'] ?? 'Unknown Doctor'}';
        dateLabel = 'Date';
        dateValue = item['appointmentDate']?.toString().split('T')[0] ?? 'N/A';
        sourceLabel = 'Location';
        sourceValue = item['location']?['name'] ?? 'Unknown';
        break;
      case 'bloodTest':
        title = 'Blood Test';
        subtitle =
            item['results'] != null ? 'Status: Completed' : 'Status: Pending';
        dateLabel = 'Date';
        dateValue = item['testDate']?.toString().split('T')[0] ?? 'N/A';
        sourceLabel = 'Lab';
        sourceValue = item['pathologyLab']?['name'] ?? 'Unknown';
        break;
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$dateLabel: $dateValue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$sourceLabel: $sourceValue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showEditDialog(
      String title, String currentValue, String firebasePath, String fieldKey,
      [bool isList = false]) async {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Edit $title',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Enter new value",
              hintStyle: TextStyle(
                color: Colors.grey[600],
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF085D2D)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final safePhone = getSafePath(_userPhone);
                  if (isList) {
                    List<String> updatedList = controller.text.isEmpty
                        ? []
                        : controller.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList();
                    await _database
                        .ref()
                        .child('users/$safePhone/$firebasePath')
                        .update({fieldKey: updatedList});
                    setState(() {
                      if (firebasePath == 'medicalHistory') {
                        medicalHistory![fieldKey] = updatedList;
                      }
                    });
                  } else {
                    await _database
                        .ref()
                        .child('users/$safePhone/$firebasePath')
                        .update({fieldKey: controller.text});
                    setState(() {
                      if (firebasePath == 'personalInformation') {
                        if (fieldKey == 'emergencyContact') {
                          personalInfo!['emergencyContact']['name'] =
                              controller.text;
                        } else {
                          personalInfo![fieldKey] = controller.text;
                        }
                      } else if (firebasePath == 'healthMetrics') {
                        if (fieldKey == 'weight' || fieldKey == 'height') {
                          healthMetrics![fieldKey] =
                              int.tryParse(controller.text) ??
                                  healthMetrics![fieldKey];
                        } else {
                          healthMetrics![fieldKey] = controller.text;
                        }
                      } else if (firebasePath == 'medicalHistory') {
                        if (fieldKey == 'surgeries') {
                          medicalHistory![fieldKey] =
                              controller.text.toLowerCase() == 'true';
                        } else {
                          medicalHistory![fieldKey] = controller.text;
                        }
                      } else if (firebasePath == 'lifestyleFactors') {
                        if (fieldKey == 'sleepHours') {
                          lifestyleFactors![fieldKey] =
                              int.tryParse(controller.text) ??
                                  lifestyleFactors![fieldKey];
                        } else {
                          lifestyleFactors![fieldKey] = controller.text;
                        }
                      }
                    });
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title updated successfully')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update $title')),
                  );
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF085D2D),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (personalInfo == null ||
        healthMetrics == null ||
        medicalHistory == null ||
        lifestyleFactors == null ||
        medications == null) {
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
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                buildInfoCard("Name", personalInfo!['name'] ?? '',
                    'personalInformation', 'name'),
                buildInfoCard("Blood Type", personalInfo!['bloodType'] ?? '',
                    'personalInformation', 'bloodType'),
                buildInfoCard("Gender", personalInfo!['gender'] ?? '',
                    'personalInformation', 'gender'),
                buildInfoCard(
                    "DOB",
                    personalInfo!['dob'] != null
                        ? personalInfo!['dob'].toString().split('T')[0]
                        : '',
                    'personalInformation',
                    'dob'),
                buildInfoCard("Phone", personalInfo!['phone'] ?? '',
                    'personalInformation', 'phone'),
                buildInfoCard(
                    "Emergency Contact",
                    personalInfo!['emergencyContact']?['name'] ?? '',
                    'personalInformation',
                    'emergencyContact'),
              ],
            ),

            // Health Metrics Section
            buildSectionTitle("Health Metrics", Icons.monitor_heart),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                buildInfoCard(
                    "Blood Pressure",
                    healthMetrics!['bloodPressure'] ?? '',
                    'healthMetrics',
                    'bloodPressure'),
                buildInfoCard(
                    "Weight",
                    "${healthMetrics!['weight']?.toString() ?? ''} kg",
                    'healthMetrics',
                    'weight'),
                buildInfoCard(
                    "Height",
                    "${healthMetrics!['height']?.toString() ?? ''} cm",
                    'healthMetrics',
                    'height'),
                buildInfoCard(
                    "BMI",
                    (healthMetrics!['weight'] != null &&
                            healthMetrics!['height'] != null)
                        ? ((healthMetrics!['weight'] /
                                ((healthMetrics!['height'] / 100) *
                                    (healthMetrics!['height'] / 100)))
                            .toStringAsFixed(1))
                        : '',
                    'healthMetrics',
                    'bmi'),
              ],
            ),

            // Medical History Section
            buildSectionTitle("Medical History", Icons.medical_services),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Chronic Conditions",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Flexible(
                                child: Text(
                                  (medicalHistory!['chronicConditions']
                                                  as List?)
                                              ?.isEmpty ??
                                          true
                                      ? "None"
                                      : medicalHistory!['chronicConditions']
                                          .join(", "),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,
                              size: 20, color: Colors.grey[600]),
                          onPressed: () => showEditDialog(
                              "Chronic Conditions",
                              (medicalHistory!['chronicConditions'] as List?)
                                          ?.isEmpty ??
                                      true
                                  ? "None"
                                  : medicalHistory!['chronicConditions']
                                      .join(", "),
                              'medicalHistory',
                              'chronicConditions',
                              true),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Family History",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Flexible(
                                child: Text(
                                  (medicalHistory!['familyHistory'] as List?)
                                              ?.isEmpty ??
                                          true
                                      ? "None"
                                      : medicalHistory!['familyHistory']
                                          .join(", "),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,
                              size: 20, color: Colors.grey[600]),
                          onPressed: () => showEditDialog(
                              "Family History",
                              (medicalHistory!['familyHistory'] as List?)
                                          ?.isEmpty ??
                                      true
                                  ? "None"
                                  : medicalHistory!['familyHistory'].join(", "),
                              'medicalHistory',
                              'familyHistory',
                              true),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Surgeries",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Flexible(
                                child: Text(
                                  medicalHistory!['surgeries']?.toString() ??
                                      'No',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,
                              size: 20, color: Colors.grey[600]),
                          onPressed: () => showEditDialog(
                              "Surgeries",
                              medicalHistory!['surgeries']?.toString() ?? 'No',
                              'medicalHistory',
                              'surgeries'),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Allergies",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Flexible(
                                child: Text(
                                  medicalHistory!['otherAllergies']
                                          ?.toString() ??
                                      'None',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,
                              size: 20, color: Colors.grey[600]),
                          onPressed: () => showEditDialog(
                              "Allergies",
                              medicalHistory!['otherAllergies']?.toString() ??
                                  'None',
                              'medicalHistory',
                              'otherAllergies'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Lifestyle Section
            buildSectionTitle("Lifestyle", Icons.fitness_center),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                buildInfoCard(
                    "Smoking",
                    lifestyleFactors!['smokingStatus'] ?? '',
                    'lifestyleFactors',
                    'smokingStatus'),
                buildInfoCard(
                    "Alcohol",
                    lifestyleFactors!['alcoholConsumption'] ?? '',
                    'lifestyleFactors',
                    'alcoholConsumption'),
                buildInfoCard(
                    "Exercise",
                    lifestyleFactors!['exerciseFrequency'] ?? '',
                    'lifestyleFactors',
                    'exerciseFrequency'),
                buildInfoCard(
                    "Sleep",
                    "${lifestyleFactors!['sleepHours']?.toString() ?? ''} hours",
                    'lifestyleFactors',
                    'sleepHours'),
              ],
            ),

            // Medications Section
            buildSectionTitle("Current Medications", Icons.medication),
            if (medications!['currentMeds'] == true &&
                medications!['medsList'] != null &&
                medications!['medsList'].isNotEmpty)
              ...(medications!['medsList'] as List).map(
                  (med) => buildInfoCard(med, "", 'medications', 'medsList'))
            else
              buildInfoCard(
                  "Current Medications", "None", 'medications', 'currentMeds'),

            // Medicine Purchases Section
            buildSectionTitle("Medicine Purchases", Icons.local_pharmacy),
            if (medicinePurchases.isNotEmpty)
              ...medicinePurchases.map<Widget>((med) {
                return buildMedicalItemCard(med, 'medicine', () async {
                  try {
                    final safePhone = getSafePath(_userPhone);
                    final updatedPurchases = List.from(medicinePurchases)
                      ..removeAt(med['index']);
                    await _database
                        .ref()
                        .child('users/$safePhone/medicinePurchases')
                        .set(updatedPurchases);
                    setState(() {
                      medicinePurchases.remove(med);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${med['name']} deleted'),
                        backgroundColor: Color(0xFF085D2D),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to delete medicine purchase')),
                    );
                  }
                });
              }).toList()
            else
              buildInfoCard("No medicine purchases",
                  "You haven't purchased any medicines yet", '', ''),

            // Appointments Section
            buildSectionTitle("Appointments", Icons.calendar_today),
            if (appointments.isNotEmpty)
              ...appointments.map<Widget>((apt) {
                return buildMedicalItemCard(apt, 'appointment', () async {
                  try {
                    final safePhone = getSafePath(_userPhone);
                    final updatedAppointments = List.from(appointments)
                      ..removeAt(apt['index']);
                    await _database
                        .ref()
                        .child('users/$safePhone/appointments')
                        .set(updatedAppointments);
                    setState(() {
                      appointments.remove(apt);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Appointment deleted'),
                        backgroundColor: Color(0xFF085D2D),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete appointment')),
                    );
                  }
                });
              }).toList()
            else
              buildInfoCard("No appointments",
                  "You don't have any upcoming appointments", '', ''),

            // Blood Tests Section
            buildSectionTitle("Blood Tests", Icons.bloodtype),
            if (bloodTests.isNotEmpty)
              ...bloodTests.map<Widget>((test) {
                return buildMedicalItemCard(test, 'bloodTest', () async {
                  try {
                    final safePhone = getSafePath(_userPhone);
                    final updatedBloodTests = List.from(bloodTests)
                      ..removeAt(test['index']);
                    await _database
                        .ref()
                        .child('users/$safePhone/bloodTests')
                        .set(updatedBloodTests);
                    setState(() {
                      bloodTests.remove(test);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Blood test deleted'),
                        backgroundColor: Color(0xFF085D2D),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete blood test')),
                    );
                  }
                });
              }).toList()
            else
              buildInfoCard("No blood tests",
                  "You don't have any blood tests scheduled", '', ''),
          ],
        ),
      ),
    );
  }
}
