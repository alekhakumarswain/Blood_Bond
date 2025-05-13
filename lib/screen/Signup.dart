import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'welcome.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passToggle = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _database;

  @override
  void initState() {
    super.initState();
    print('Initializing SignupScreen');
    _database = FirebaseDatabase.instance.ref();
  }

  String getSafePath(String phone) {
    return phone.replaceAll(RegExp(r'[.#$/[\]]'), '_');
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        // Step 1: Register user with Firebase Authentication
        print('Attempting Firebase Auth with email: ${_emailController.text}');
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user == null) {
          throw Exception('No authenticated user found');
        }

        String userId = userCredential.user!.uid;
        String mobileNumber = _mobileController.text.trim();
        String safeMobile = getSafePath(mobileNumber);
        print('User ID: $userId, Safe Mobile: $safeMobile');

        // Step 2: Add a slight delay to ensure authentication is fully processed
        print('Waiting for authentication to settle...');
        await Future.delayed(const Duration(seconds: 2));
        print('Current user: ${_auth.currentUser?.uid}');

        // Step 3: Prepare user data for Firebase Realtime Database
        final userData = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': mobileNumber,
          'bloodType': '',
          'dob': '',
          'gender': '',
          'address': '',
          'occupation': '',
          'emergencyContact': {
            'name': '',
            'phone': '',
          },
          'systemMetadata': {
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
            'version': 1,
          },
        };
        print('User data to save: $userData');

        // Step 4: Save user data to Firebase Realtime Database
        try {
          print('Saving to database path: users/$safeMobile');
          DatabaseReference userRef = _database.child('users/$safeMobile');
          await userRef.set(userData).timeout(const Duration(seconds: 10),
              onTimeout: () {
            throw Exception(
                'Database write timed out. Please check your connection.');
          });
          print('Database save successful');
        } catch (dbError) {
          print('Database error: $dbError');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save user data to database: $dbError'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
        }

        // Step 5: Save minimal data locally using SharedPreferences
        print('Saving to SharedPreferences');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('name', _nameController.text.trim());
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('phone', mobileNumber);
        print('SharedPreferences save successful');

        // Step 6: Show success message and navigate
        print('Signup successful, navigating to LoginScreen');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup successful! Please log in.'),
            backgroundColor: Colors.green,
          ),
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } catch (e, stackTrace) {
        print('Signup error: $e');
        print('Stack trace: $stackTrace');
        String errorMessage = 'Failed to sign up';
        if (e.toString().contains('PERMISSION_DENIED')) {
          errorMessage = 'Permission denied. Check database rules.';
        } else if (e.toString().contains('network') ||
            e.toString().contains('timed out')) {
          errorMessage = 'Network error. Please check your connection.';
        } else if (e.toString().contains('email-already-in-use')) {
          errorMessage = 'The email address is already in use.';
        } else if (e.toString().contains('invalid-email')) {
          errorMessage = 'The email address is invalid.';
        } else if (e.toString().contains('weak-password')) {
          errorMessage = 'The password is too weak.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } else {
      print('Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  "assets/images/doctors.png",
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                shadowColor: const Color(0xFFD32F2F).withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle:
                                const TextStyle(color: Color(0xFF616161)),
                            prefixIcon: const Icon(Icons.person,
                                color: Color(0xFFD32F2F)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF616161)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD32F2F)),
                            ),
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Enter your full name'
                              : null,
                          style: const TextStyle(color: Color(0xFF212121)),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle:
                                const TextStyle(color: Color(0xFF616161)),
                            prefixIcon: const Icon(Icons.email,
                                color: Color(0xFFD32F2F)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF616161)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD32F2F)),
                            ),
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
                          style: const TextStyle(color: Color(0xFF212121)),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            labelStyle:
                                const TextStyle(color: Color(0xFF616161)),
                            prefixIcon: const Icon(Icons.phone,
                                color: Color(0xFFD32F2F)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF616161)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD32F2F)),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter your mobile number';
                            }
                            if (!RegExp(r'^\+?[0-9]{10,13}$')
                                .hasMatch(value!)) {
                              return 'Enter a valid mobile number';
                            }
                            return null;
                          },
                          style: const TextStyle(color: Color(0xFF212121)),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: passToggle,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                const TextStyle(color: Color(0xFF616161)),
                            prefixIcon: const Icon(Icons.lock,
                                color: Color(0xFFD32F2F)),
                            suffixIcon: InkWell(
                              onTap: () =>
                                  setState(() => passToggle = !passToggle),
                              child: Icon(
                                passToggle
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                                color: const Color(0xFFD32F2F),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF616161)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD32F2F)),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter a password';
                            }
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          style: const TextStyle(color: Color(0xFF212121)),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFA726),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Sign Up'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF616161)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                ),
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD32F2F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
