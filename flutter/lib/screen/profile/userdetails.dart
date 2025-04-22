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

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green[800]),
      ),
    );
  }

  Widget buildKeyValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$key: ",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget buildListRow(String key, List<dynamic> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$key: ",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(values.join(", "))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (profileData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("User Details"),
          backgroundColor: Color(0xFF085D2D),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final personalInfo = profileData!['personalInformation'] ?? {};
    final insuranceInfo = profileData!['insuranceInformation'] ?? {};
    final bloodDonationHistory = profileData!['bloodDonationHistory'] ?? {};
    final healthMetrics = profileData!['healthMetrics'] ?? {};
    final medicalHistory = profileData!['medicalHistory'] ?? {};
    final medications = profileData!['medications'] ?? {};
    final medicalReports = profileData!['medicalReports'] ?? {};
    final vaccinationHistory = profileData!['vaccinationHistory'] ?? {};
    final lifestyleFactors = profileData!['lifestyleFactors'] ?? {};
    final currentHealthStatus = profileData!['currentHealthStatus'] ?? {};
    final medicinePurchases = profileData!['medicinePurchases'] ?? [];
    final appointments = profileData!['appointments'] ?? [];
    final bloodTests = profileData!['bloodTests'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        backgroundColor: Color(0xFF085D2D),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("Personal Information"),
            buildKeyValueRow("Name", personalInfo['name'] ?? ''),
            buildKeyValueRow("Date of Birth",
                personalInfo['dob']?.toString().split('T')[0] ?? ''),
            buildKeyValueRow("Gender", personalInfo['gender'] ?? ''),
            buildKeyValueRow("Blood Type", personalInfo['bloodType'] ?? ''),
            buildKeyValueRow("Phone", personalInfo['phone'] ?? ''),
            buildKeyValueRow("Address", personalInfo['address'] ?? ''),
            buildKeyValueRow("Occupation", personalInfo['occupation'] ?? ''),
            buildKeyValueRow("Emergency Contact Name",
                personalInfo['emergencyContact']?['name'] ?? ''),
            buildKeyValueRow("Emergency Contact Phone",
                personalInfo['emergencyContact']?['phone'] ?? ''),
            buildSectionTitle("Insurance Information"),
            buildKeyValueRow("Provider", insuranceInfo['provider'] ?? ''),
            buildKeyValueRow(
                "Policy Number", insuranceInfo['policyNumber'] ?? ''),
            buildSectionTitle("Blood Donation History"),
            buildKeyValueRow(
                "Last Donation Date",
                bloodDonationHistory['lastDonationDate']
                        ?.toString()
                        .split('T')[0] ??
                    ''),
            buildKeyValueRow("Total Donations",
                bloodDonationHistory['totalDonations']?.toString() ?? ''),
            buildKeyValueRow("Eligible For Donation",
                bloodDonationHistory['eligibleForDonation']?.toString() ?? ''),
            buildSectionTitle("Health Metrics"),
            buildKeyValueRow(
                "Blood Pressure", healthMetrics['bloodPressure'] ?? ''),
            buildKeyValueRow(
                "Weight", healthMetrics['weight']?.toString() ?? ''),
            buildKeyValueRow(
                "Height", healthMetrics['height']?.toString() ?? ''),
            buildSectionTitle("Medical History"),
            buildListRow("Chronic Conditions",
                medicalHistory['chronicConditions'] ?? []),
            buildKeyValueRow(
                "Surgeries", medicalHistory['surgeries']?.toString() ?? ''),
            buildKeyValueRow(
                "Surgery Details", medicalHistory['surgeryDetails'] ?? ''),
            buildListRow("Medication Allergies",
                medicalHistory['medicationAllergies'] ?? []),
            buildKeyValueRow(
                "Other Allergies", medicalHistory['otherAllergies'] ?? ''),
            buildListRow(
                "Family History", medicalHistory['familyHistory'] ?? []),
            buildKeyValueRow("Other Family History",
                medicalHistory['otherFamilyHistory'] ?? ''),
            buildSectionTitle("Medications"),
            buildKeyValueRow("Current Medications",
                medications['currentMeds']?.toString() ?? ''),
            buildListRow("Medications List", medications['medsList'] ?? []),
            buildKeyValueRow("Past Medications", medications['pastMeds'] ?? ''),
            buildListRow(
                "Ongoing Therapies", medications['ongoingTherapies'] ?? []),
            buildKeyValueRow("Ongoing Therapies Others",
                medications['ongoingTherapiesOthers'] ?? ''),
            buildSectionTitle("Medical Reports"),
            buildKeyValueRow(
                "Blood Report", medicalReports['bloodReport'] ?? ''),
            buildKeyValueRow(
                "Imaging Report", medicalReports['imagingReport'] ?? ''),
            buildKeyValueRow("Genetic Or Biopsy Test",
                medicalReports['geneticOrBiopsyTest']?.toString() ?? ''),
            buildSectionTitle("Vaccination History"),
            buildKeyValueRow("Polio Vaccine",
                vaccinationHistory['polioVaccine']?.toString() ?? ''),
            buildKeyValueRow("Tetanus Shot",
                vaccinationHistory['tetanusShot']?.toString() ?? ''),
            buildKeyValueRow(
                "Covid Vaccine", vaccinationHistory['covidVaccine'] ?? ''),
            buildKeyValueRow("Covid Booster",
                vaccinationHistory['covidBooster']?.toString() ?? ''),
            buildSectionTitle("Lifestyle Factors"),
            buildKeyValueRow(
                "Smoking Status", lifestyleFactors['smokingStatus'] ?? ''),
            buildKeyValueRow("Cigarettes Per Day",
                lifestyleFactors['cigarettesPerDay']?.toString() ?? ''),
            buildKeyValueRow("Exercise Frequency",
                lifestyleFactors['exerciseFrequency'] ?? ''),
            buildKeyValueRow("Sleep Hours",
                lifestyleFactors['sleepHours']?.toString() ?? ''),
            buildListRow("Diet Type", lifestyleFactors['dietType'] ?? []),
            buildKeyValueRow(
                "Diet Type Other", lifestyleFactors['dietTypeOther'] ?? ''),
            buildKeyValueRow("Alcohol Consumption",
                lifestyleFactors['alcoholConsumption'] ?? ''),
            buildKeyValueRow("Alcohol Frequency",
                lifestyleFactors['alcoholFrequency'] ?? ''),
            buildSectionTitle("Current Health Status"),
            buildKeyValueRow("Primary Symptoms",
                currentHealthStatus['primarySymptoms'] ?? ''),
            buildKeyValueRow("Initial Diagnosis",
                currentHealthStatus['initialDiagnosis'] ?? ''),
            buildKeyValueRow("Follow Up Required",
                currentHealthStatus['followUpRequired']?.toString() ?? ''),
            buildKeyValueRow("Follow Up Date",
                currentHealthStatus['followUpDate']?.toString() ?? ''),
            buildSectionTitle("Medicine Purchases"),
            ...medicinePurchases.map<Widget>((med) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med['name'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    buildKeyValueRow("Price", med['price']?.toString() ?? ''),
                    buildKeyValueRow("Dosage", med['dosage'] ?? ''),
                    buildKeyValueRow("Category", med['category'] ?? ''),
                    buildKeyValueRow(
                        "Quantity", med['quantity']?.toString() ?? ''),
                    buildKeyValueRow(
                        "Store Name", med['store']?['storeName'] ?? ''),
                    buildKeyValueRow(
                        "Store Address", med['store']?['address'] ?? ''),
                    buildKeyValueRow(
                        "Purchase Date", med['purchaseDate'] ?? ''),
                    buildKeyValueRow(
                        "Next Refill Date", med['nextRefillDate'] ?? ''),
                  ],
                ),
              );
            }).toList(),
            buildSectionTitle("Appointments"),
            ...appointments.map<Widget>((apt) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(apt['doctorName'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    buildKeyValueRow("Specialty", apt['specialty'] ?? ''),
                    buildKeyValueRow(
                        "Hospital Name", apt['hospitalName'] ?? ''),
                    buildKeyValueRow(
                        "Appointment Date", apt['appointmentDate'] ?? ''),
                    buildKeyValueRow(
                        "Appointment Time", apt['appointmentTime'] ?? ''),
                    buildKeyValueRow(
                        "Appointment Type", apt['appointmentType'] ?? ''),
                    buildKeyValueRow("Address", apt['address'] ?? ''),
                    buildKeyValueRow("Status", apt['status'] ?? ''),
                    buildKeyValueRow("Notes", apt['notes'] ?? ''),
                    if (apt['virtualMeetingUrl'] != null)
                      buildKeyValueRow("Virtual Meeting URL",
                          apt['virtualMeetingUrl'] ?? ''),
                  ],
                ),
              );
            }).toList(),
            buildSectionTitle("Blood Tests"),
            ...bloodTests.map<Widget>((test) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildKeyValueRow("Test Type", test['testType'] ?? ''),
                    buildKeyValueRow("Test Date", test['testDate'] ?? ''),
                    buildKeyValueRow("Test Time", test['testTime'] ?? ''),
                    buildKeyValueRow("Price", test['price']?.toString() ?? ''),
                    buildKeyValueRow("Status", test['status'] ?? ''),
                    buildKeyValueRow("Preparation Instructions",
                        test['preparationInstructions'] ?? ''),
                    buildKeyValueRow("Results Available",
                        test['resultsAvailable']?.toString() ?? ''),
                    if (test['results'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (test['results'] as Map<String, dynamic>)
                              .entries
                              .map((entry) {
                            return buildKeyValueRow(
                                entry.key, entry.value.toString());
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
