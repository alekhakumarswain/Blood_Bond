import 'package:blood_bond/screen/Login.dart';
import 'package:blood_bond/screen/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passToggle = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  // Variables for dropdown selections
  String? _selectedBloodType;
  String? _selectedGender;
  String? _selectedLanguage;
  DateTime? selectedDate;

  // Lists for dropdown options
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _languages = ['English', 'Spanish', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the user ID from the created user
        String userId = userCredential.user!.uid;

        // Create comprehensive user profile in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'personalInformation': {
            'name': _nameController.text.trim(),
            'dob': selectedDate?.toIso8601String(),
            'gender': _selectedGender ?? '',
            'bloodType': _selectedBloodType ?? '',
            'phone': _phoneController.text.trim(),
            'emergencyContact': {
              'name': _emergencyNameController.text.trim(),
              'phone': _emergencyPhoneController.text.trim(),
            },
            'address': _addressController.text.trim(),
            'occupation': _occupationController.text.trim(),
            'preferredLanguage': _selectedLanguage ?? '',
          },
          'insuranceInformation': {
            'provider': '',
            'policyNumber': '',
            'insuranceFile': ''
          },
          'bloodDonationHistory': {
            'lastDonationDate': null,
            'totalDonations': 0,
            'eligibleForDonation': true
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
            'weightManagement': {'targetWeight': 0, 'targetDate': null},
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
            'lastSync': null,
            'connectedApps': []
          },
          'healthInsurance': {
            'provider': '',
            'policyNumber': '',
            'validUntil': null,
            'coverageAmount': 0,
            'networkHospitals': []
          },
          'systemMetadata': {
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'version': 1
          },
          'auth': {
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'lastLogin': null,
            'accountStatus': 'active'
          }
        });

        // Navigate to login screen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'An error occurred. Please try again.';

        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF1EFEF),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF020012)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset("assets/images/doctors.png"),
                ),
                SizedBox(height: 8),

                // Personal Information Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF020012),
                    ),
                  ),
                ),

                // Full Name Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                ),

                // Date of Birth Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                ),

                // Gender Dropdown
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: "Gender",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    hint: Text("Select Gender",
                        style: TextStyle(color: Colors.black)),
                    items: _genders.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child:
                            Text(gender, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                    dropdownColor:
                        Colors.white, // Ensure dropdown background is white
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                ),

                // Blood Type Dropdown
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _selectedBloodType,
                    decoration: InputDecoration(
                      labelText: "Blood Type",
                      prefixIcon: Icon(Icons.bloodtype),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    hint: Text("Select Blood Type",
                        style: TextStyle(color: Colors.black)),
                    items: _bloodTypes.map((bloodType) {
                      return DropdownMenuItem<String>(
                        value: bloodType,
                        child: Text(bloodType,
                            style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBloodType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your blood type';
                      }
                      return null;
                    },
                    dropdownColor:
                        Colors.white, // Ensure dropdown background is white
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                ),

                // Occupation Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _occupationController,
                    decoration: InputDecoration(
                      labelText: "Occupation (Optional)",
                      prefixIcon: Icon(Icons.work),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                  ),
                ),

                // Emergency Contact Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Emergency Contact",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF020012),
                    ),
                  ),
                ),

                // Emergency Contact Name
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _emergencyNameController,
                    decoration: InputDecoration(
                      labelText: "Emergency Contact Name",
                      prefixIcon: Icon(Icons.emergency),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter emergency contact name';
                      }
                      return null;
                    },
                  ),
                ),

                // Emergency Contact Phone
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _emergencyPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Emergency Contact Phone",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter emergency contact phone';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),

                // Account Information Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Account Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF020012),
                    ),
                  ),
                ),

                // Email Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                // Phone Number Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),

                // Address Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "Address",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ),

                // Preferred Language Dropdown
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: "Preferred Language",
                      prefixIcon: Icon(Icons.language),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    hint: Text("Select Language",
                        style: TextStyle(color: Colors.black)),
                    items: _languages.map((language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language,
                            style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your preferred language';
                      }
                      return null;
                    },
                    dropdownColor:
                        Colors.white, // Ensure dropdown background is white
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                ),

                // Password Field
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: passToggle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: "Enter Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        child: Icon(
                          passToggle
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Sign Up Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Color(0xFF0BDF5F),
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: isLoading ? null : _signUp,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Already have an account? Log In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
