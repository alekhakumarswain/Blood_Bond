import 'package:blood_bond/screen/Login.dart';
import 'package:blood_bond/screen/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passToggle = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for minimal fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      print('Form is valid. Proceeding with signup...');
      setState(() => isLoading = true);

      try {
        // Firebase Authentication
        print('Attempting to create user with email: ${_emailController.text}');
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print('User created successfully: ${userCredential.user?.uid}');

        if (userCredential.user == null) {
          throw 'No authenticated user found';
        }

        // Simplified flat user data
        Map<String, dynamic> userData = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
        };

        // Save to Firestore
        print(
            'Saving user data to Firestore for UID: ${userCredential.user!.uid}');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);
        print('User data saved to Firestore successfully.');

        // Navigate to LoginScreen
        print('Signup successful! Navigating to LoginScreen...');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } catch (e) {
        print('Error during signup: $e');
        _showErrorSnackbar('Signup failed: $e');
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } else {
      print('Form validation failed.');
      _showErrorSnackbar('Please fill all required fields correctly.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1EFEF),
      body: SingleChildScrollView(
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset("assets/images/doctors.png"),
                ),
                SizedBox(height: 8),

                // Name Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your full name'
                        : null,
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
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF020012), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Please enter your email';
                      if (!value!.contains('@'))
                        return 'Please enter a valid email';
                      return null;
                    },
                  ),
                ),

                // Password Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: passToggle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Enter Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () => setState(() => passToggle = !passToggle),
                        child: Icon(passToggle
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Please enter a password';
                      if (value!.length < 6)
                        return 'Password must be at least 6 characters';
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

                // Login Link
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
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
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
