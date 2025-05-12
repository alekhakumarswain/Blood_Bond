import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Save the full profile to Realtime Database
        Map<String, dynamic> profileData = {
          'personalInformation': {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'dob': '',
            'gender': '',
            'bloodType': '',
            'emergencyContact': {'name': '', 'phone': ''},
            'occupation': ''
          },
          'insuranceInformation': {
            'provider': '',
            'policyNumber': '',
            'insuranceFile': ''
          },
          'bloodDonationHistory': {
            'lastDonationDate': '',
            'totalDonations': 0,
            'eligibleForDonation': false
          },
          'healthMetrics': {
            'bloodPressure': '',
            'heartRate': 0,
            'weight': 0,
            'height': 0
          },
          'medicalHistory': {
            'chronicConditions': [],
            'surgeries': false,
            'surgeryDetails': '',
            'medicationAllergies': [],
            'otherAllergies': '',
            'familyHistory': [],
            'otherFamilyHistory': ''
          },
          'medications': {
            'currentMeds': false,
            'medsList': [],
            'pastMeds': '',
            'ongoingTherapies': [],
            'ongoingTherapiesOthers': ''
          },
          'medicalReports': {
            'bloodReport': '',
            'imagingReport': '',
            'geneticOrBiopsyTest': false
          },
          'vaccinationHistory': {
            'polioVaccine': false,
            'tetanusShot': null,
            'covidVaccine': '',
            'covidBooster': false
          },
          'lifestyleFactors': {
            'smokingStatus': '',
            'cigarettesPerDay': 0,
            'exerciseFrequency': '',
            'sleepHours': 0,
            'dietType': [],
            'dietTypeOther': '',
            'alcoholConsumption': '',
            'alcoholFrequency': ''
          },
          'currentHealthStatus': {
            'primarySymptoms': '',
            'initialDiagnosis': '',
            'followUpRequired': false,
            'followUpDate': null
          },
          'bloodDonationRequests': {
            'donationHistory': [],
            'receiveRequests': []
          },
          'medicinePurchases': [],
          'appointments': [],
          'bloodTests': [],
          'healthGoals': {
            'weightManagement': {'targetWeight': 0, 'targetDate': ''},
            'fitnessGoals': [],
            'nutritionGoals': []
          },
          'healthReminders': {
            'medicationReminders': [],
            'appointmentReminders': false,
            'waterIntakeReminder': {
              'enabled': false,
              'targetAmount': 0,
              'interval': 0
            }
          },
          'deviceConnections': {
            'fitnessTracker': '',
            'lastSync': '',
            'connectedApps': []
          },
          'healthInsurance': {
            'provider': '',
            'policyNumber': '',
            'validUntil': '',
            'coverageAmount': 0,
            'networkHospitals': []
          },
          'systemMetadata': {
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'version': 1
          }
        };

        await FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .set(profileData);

        // Clear shared_preferences after saving to Realtime Database
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        // Navigate back to NavScreen or HomeScreen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Enter your full name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter your email';
                  }
                  if (!value!.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Enter your phone number' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Enter your address' : null,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA726),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Update Profile',
                          style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
