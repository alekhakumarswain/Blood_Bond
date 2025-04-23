import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class HealthRecordsScreen extends StatefulWidget {
  @override
  _HealthRecordsScreenState createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  final Color primaryColor = Color(0xFF6A1B9A); // Deep purple
  final Color secondaryColor = Color(0xFF9C27B0); // Purple
  final Color accentColor = Color(0xFFE1BEE7); // Light purple
  final Color textColor = Colors.grey[800]!;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/Data/profile.json');
      setState(() {
        profileData = json.decode(jsonString);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data')),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value, {IconData? icon}) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: icon != null ? Icon(icon, color: secondaryColor) : null,
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value ?? 'Not specified',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildExpandableInfoTile(String label, List<Widget> children) {
    return ExpansionTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
      ),
      children: children,
    );
  }

  Widget _buildMedicalItemCard(Map<String, dynamic> item, String type) {
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
            Text(
              item['name'] ??
                  item['testType'] ??
                  item['doctorName'] ??
                  'Record',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 8),
            if (type == 'medicine') ...[
              _buildInfoRow("Dosage", item['dosage'] ?? 'Not specified'),
              _buildInfoRow("Category", item['category'] ?? 'Not specified'),
              _buildInfoRow(
                  "Quantity", item['quantity']?.toString() ?? 'Not specified'),
              _buildInfoRow(
                  "Store", item['store']?['storeName'] ?? 'Not specified'),
              _buildInfoRow(
                  "Purchase Date", item['purchaseDate'] ?? 'Not specified'),
              _buildInfoRow(
                  "Next Refill", item['nextRefillDate'] ?? 'Not specified'),
            ] else if (type == 'appointment') ...[
              _buildInfoRow("Doctor", item['doctorName'] ?? 'Not specified'),
              _buildInfoRow("Specialty", item['specialty'] ?? 'Not specified'),
              _buildInfoRow(
                  "Hospital", item['hospitalName'] ?? 'Not specified'),
              _buildInfoRow("Date", item['appointmentDate'] ?? 'Not specified'),
              _buildInfoRow("Time", item['appointmentTime'] ?? 'Not specified'),
              _buildInfoRow("Type", item['appointmentType'] ?? 'Not specified'),
              _buildInfoRow("Status", item['status'] ?? 'Not specified'),
              if (item['virtualMeetingUrl'] != null)
                _buildInfoRow("Meeting Link", item['virtualMeetingUrl'] ?? ''),
              if (item['notes'] != null)
                _buildInfoRow("Notes", item['notes'] ?? ''),
            ] else if (type == 'bloodTest') ...[
              _buildInfoRow("Test Type", item['testType'] ?? 'Not specified'),
              _buildInfoRow(
                  "Lab", item['pathologyLab']?['labName'] ?? 'Not specified'),
              _buildInfoRow("Date", item['testDate'] ?? 'Not specified'),
              _buildInfoRow("Time", item['testTime'] ?? 'Not specified'),
              _buildInfoRow("Status", item['status'] ?? 'Not specified'),
              _buildInfoRow("Price", "₹${item['price']?.toString() ?? ''}"),
              if (item['resultsAvailable'] == true) ...[
                SizedBox(height: 8),
                Text(
                  "Test Results:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                ...(item['results'] as Map<String, dynamic>?)?.entries.map((e) {
                      return _buildInfoRow(e.key, e.value.toString());
                    })?.toList() ??
                    [],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
              value.isEmpty ? "Not specified" : value,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    final personalInfo = profileData!['personalInformation'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Personal Information'),
        _buildInfoTile('Name', personalInfo['name'], icon: Icons.person),
        _buildInfoTile(
          'Date of Birth',
          personalInfo['dob']?.toString().split('T')[0],
          icon: Icons.cake,
        ),
        _buildInfoTile('Gender', personalInfo['gender'],
            icon: Icons.transgender),
        _buildInfoTile('Blood Type', personalInfo['bloodType'],
            icon: Icons.bloodtype),
        _buildInfoTile('Phone', personalInfo['phone'], icon: Icons.phone),
        _buildInfoTile('Address', personalInfo['address'], icon: Icons.home),
        _buildInfoTile(
          'Emergency Contact',
          '${personalInfo['emergencyContact']?['name']}\n${personalInfo['emergencyContact']?['phone']}',
          icon: Icons.emergency,
        ),
        _buildInfoTile('Occupation', personalInfo['occupation'],
            icon: Icons.work),
      ],
    );
  }

  Widget _buildHealthMetricsSection() {
    final healthMetrics = profileData!['healthMetrics'] ?? {};
    double bmi = healthMetrics['weight'] != null &&
            healthMetrics['height'] != null
        ? healthMetrics['weight'] /
            ((healthMetrics['height'] / 100) * (healthMetrics['height'] / 100))
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Health Metrics'),
        _buildInfoTile('Blood Pressure', healthMetrics['bloodPressure'],
            icon: Icons.monitor_heart),
        _buildInfoTile('Heart Rate', '${healthMetrics['heartRate']} bpm',
            icon: Icons.favorite),
        _buildInfoTile('Weight', '${healthMetrics['weight']} kg',
            icon: Icons.line_weight),
        _buildInfoTile('Height', '${healthMetrics['height']} cm',
            icon: Icons.height),
        _buildInfoTile('BMI', bmi.toStringAsFixed(1), icon: Icons.calculate),
      ],
    );
  }

  Widget _buildMedicalHistorySection() {
    final medicalHistory = profileData!['medicalHistory'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Medical History'),
        _buildInfoTile(
          'Chronic Conditions',
          (medicalHistory['chronicConditions'] as List?)?.join(', ') ?? 'None',
          icon: Icons.medical_services,
        ),
        _buildInfoTile(
          'Surgeries',
          medicalHistory['surgeries']?.toString() ?? 'No',
          icon: Icons.local_hospital,
        ),
        if (medicalHistory['surgeries'] == true)
          _buildInfoTile(
            'Surgery Details',
            medicalHistory['surgeryDetails'] ?? 'No details',
            icon: Icons.info,
          ),
        _buildInfoTile(
          'Medication Allergies',
          (medicalHistory['medicationAllergies'] as List?)?.join(', ') ??
              'None',
          icon: Icons.warning,
        ),
        _buildInfoTile(
          'Other Allergies',
          medicalHistory['otherAllergies'] ?? 'None',
          icon: Icons.warning_amber,
        ),
        _buildInfoTile(
          'Family History',
          (medicalHistory['familyHistory'] as List?)?.join(', ') ?? 'None',
          icon: Icons.family_restroom,
        ),
      ],
    );
  }

  Widget _buildMedicationsSection() {
    final medications = profileData!['medications'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Medications'),
        _buildInfoTile(
          'Current Medications',
          medications['currentMeds']?.toString() ?? 'No',
          icon: Icons.medication,
        ),
        if (medications['currentMeds'] == true)
          _buildInfoTile(
            'Medication List',
            (medications['medsList'] as List?)?.join(', ') ?? 'None',
            icon: Icons.list,
          ),
        _buildInfoTile(
          'Past Medications',
          medications['pastMeds'] ?? 'None',
          icon: Icons.history,
        ),
        _buildInfoTile(
          'Ongoing Therapies',
          (medications['ongoingTherapies'] as List?)?.join(', ') ?? 'None',
          icon: Icons.healing,
        ),
      ],
    );
  }

  Widget _buildLifestyleSection() {
    final lifestyle = profileData!['lifestyleFactors'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Lifestyle'),
        _buildInfoTile('Smoking Status', lifestyle['smokingStatus'],
            icon: Icons.smoking_rooms),
        if (lifestyle['smokingStatus'] != 'Never')
          _buildInfoTile(
              'Cigarettes/Day', lifestyle['cigarettesPerDay']?.toString(),
              icon: Icons.smoke_free),
        _buildInfoTile('Exercise Frequency', lifestyle['exerciseFrequency'],
            icon: Icons.directions_run),
        _buildInfoTile('Sleep Hours', '${lifestyle['sleepHours']} hours',
            icon: Icons.bedtime),
        _buildInfoTile(
            'Diet Type', (lifestyle['dietType'] as List?)?.join(', ') ?? 'None',
            icon: Icons.restaurant),
        _buildInfoTile('Alcohol Consumption', lifestyle['alcoholConsumption'],
            icon: Icons.local_bar),
        if (lifestyle['alcoholConsumption'] != 'Never')
          _buildInfoTile('Alcohol Frequency', lifestyle['alcoholFrequency'],
              icon: Icons.timer),
      ],
    );
  }

  Widget _buildVaccinationSection() {
    final vaccinations = profileData!['vaccinationHistory'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Vaccinations'),
        _buildInfoTile('Polio Vaccine',
            vaccinations['polioVaccine']?.toString() ?? 'Unknown',
            icon: Icons.vaccines),
        _buildInfoTile('Tetanus Shot',
            vaccinations['tetanusShot']?.toString() ?? 'Unknown',
            icon: Icons.medical_services),
        _buildInfoTile(
            'COVID Vaccine', vaccinations['covidVaccine'] ?? 'Not specified',
            icon: Icons.coronavirus),
        _buildInfoTile(
            'COVID Booster', vaccinations['covidBooster']?.toString() ?? 'No',
            icon: Icons.health_and_safety),
      ],
    );
  }

  Widget _buildBloodDonationSection() {
    final bloodDonation = profileData!['bloodDonationHistory'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Blood Donation'),
        _buildInfoTile(
          'Last Donation',
          bloodDonation['lastDonationDate']?.toString().split('T')[0] ??
              'Never',
          icon: Icons.bloodtype,
        ),
        _buildInfoTile(
          'Total Donations',
          bloodDonation['totalDonations']?.toString() ?? '0',
          icon: Icons.format_list_numbered,
        ),
        _buildInfoTile(
          'Eligible for Donation',
          bloodDonation['eligibleForDonation']?.toString() ?? 'Unknown',
          icon: Icons.check_circle,
        ),
      ],
    );
  }

  Widget _buildHealthGoalsSection() {
    final healthGoals = profileData!['healthGoals'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Health Goals'),
        if (healthGoals['weightManagement'] != null)
          _buildExpandableInfoTile(
            'Weight Management',
            [
              _buildInfoTile('Target Weight',
                  '${healthGoals['weightManagement']?['targetWeight']} kg'),
              _buildInfoTile('Target Date',
                  healthGoals['weightManagement']?['targetDate']),
            ],
          ),
        if (healthGoals['fitnessGoals'] != null &&
            (healthGoals['fitnessGoals'] as List).isNotEmpty)
          _buildInfoTile(
            'Fitness Goals',
            (healthGoals['fitnessGoals'] as List).join('\n'),
            icon: Icons.directions_run,
          ),
        if (healthGoals['nutritionGoals'] != null &&
            (healthGoals['nutritionGoals'] as List).isNotEmpty)
          _buildInfoTile(
            'Nutrition Goals',
            (healthGoals['nutritionGoals'] as List).join('\n'),
            icon: Icons.restaurant,
          ),
      ],
    );
  }

  Widget _buildHealthRemindersSection() {
    final healthReminders = profileData!['healthReminders'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Health Reminders'),
        _buildInfoTile(
          'Appointment Reminders',
          healthReminders['appointmentReminders']?.toString() ?? 'No',
          icon: Icons.calendar_today,
        ),
        if (healthReminders['medicationReminders'] != null &&
            (healthReminders['medicationReminders'] as List).isNotEmpty)
          _buildExpandableInfoTile(
            'Medication Reminders',
            (healthReminders['medicationReminders'] as List)
                .map<Widget>((reminder) {
              return Column(
                children: [
                  _buildInfoTile('Medication', reminder['medicationName']),
                  _buildInfoTile('Dosage', reminder['dosage']),
                  _buildInfoTile(
                      'Times', (reminder['times'] as List).join(', ')),
                  _buildInfoTile('Days', (reminder['days'] as List).join(', ')),
                  Divider(),
                ],
              );
            }).toList(),
          ),
        if (healthReminders['waterIntakeReminder'] != null)
          _buildExpandableInfoTile(
            'Water Intake Reminder',
            [
              _buildInfoTile(
                  'Enabled',
                  healthReminders['waterIntakeReminder']?['enabled']
                          ?.toString() ??
                      'No'),
              _buildInfoTile('Target Amount',
                  '${healthReminders['waterIntakeReminder']?['targetAmount']} ml'),
              _buildInfoTile('Reminder Interval',
                  'Every ${healthReminders['waterIntakeReminder']?['interval']} minutes'),
            ],
          ),
      ],
    );
  }

  Widget _buildDeviceConnectionsSection() {
    final devices = profileData!['deviceConnections'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Device Connections'),
        _buildInfoTile('Fitness Tracker', devices['fitnessTracker'],
            icon: Icons.fitness_center),
        _buildInfoTile(
            'Last Sync', devices['lastSync']?.toString().split('T')[0],
            icon: Icons.sync),
        _buildInfoTile(
          'Connected Apps',
          (devices['connectedApps'] as List?)?.join(', ') ?? 'None',
          icon: Icons.apps,
        ),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    final insurance = profileData!['healthInsurance'] ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Health Insurance'),
        _buildInfoTile('Provider', insurance['provider'],
            icon: Icons.verified_user),
        _buildInfoTile('Policy Number', insurance['policyNumber'],
            icon: Icons.confirmation_number),
        _buildInfoTile('Valid Until', insurance['validUntil'],
            icon: Icons.date_range),
        _buildInfoTile('Coverage Amount', '₹${insurance['coverageAmount']}',
            icon: Icons.attach_money),
        _buildInfoTile(
          'Network Hospitals',
          (insurance['networkHospitals'] as List?)?.join(', ') ?? 'None',
          icon: Icons.local_hospital,
        ),
      ],
    );
  }

  Widget _buildMedicinePurchasesSection() {
    final medicines = profileData!['medicinePurchases'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Medicine Purchases'),
        if (medicines.isEmpty)
          _buildInfoTile('No medicine purchases',
              'You haven\'t purchased any medicines yet'),
        ...medicines.map((med) => _buildMedicalItemCard(med, 'medicine')),
      ],
    );
  }

  Widget _buildAppointmentsSection() {
    final appointments = profileData!['appointments'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Appointments'),
        if (appointments.isEmpty)
          _buildInfoTile(
              'No appointments', 'You don\'t have any appointments scheduled'),
        ...appointments.map((apt) => _buildMedicalItemCard(apt, 'appointment')),
      ],
    );
  }

  Widget _buildBloodTestsSection() {
    final bloodTests = profileData!['bloodTests'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Blood Tests'),
        if (bloodTests.isEmpty)
          _buildInfoTile(
              'No blood tests', 'You don\'t have any blood tests scheduled'),
        ...bloodTests.map((test) => _buildMedicalItemCard(test, 'bloodTest')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Health Records'),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profileData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Health Records'),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: Center(
          child: Text('Failed to load health records'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Health Records'),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadProfileData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalInfoSection(),
            _buildHealthMetricsSection(),
            _buildMedicalHistorySection(),
            _buildMedicationsSection(),
            _buildLifestyleSection(),
            _buildVaccinationSection(),
            _buildBloodDonationSection(),
            _buildHealthGoalsSection(),
            _buildHealthRemindersSection(),
            _buildDeviceConnectionsSection(),
            _buildInsuranceSection(),
            _buildMedicinePurchasesSection(),
            _buildAppointmentsSection(),
            _buildBloodTestsSection(),
          ],
        ),
      ),
    );
  }
}
