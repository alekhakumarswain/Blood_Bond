import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        // Step 1: Register user with Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user == null) {
          throw Exception('No authenticated user found');
        }

        String userId = userCredential.user!.uid;

        // Step 2: Save minimal data locally using shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('name', _nameController.text.trim());
        await prefs.setString('email', _emailController.text.trim());

        // Step 3: Navigate to LoginScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } catch (e) {
        _showErrorSnackbar('Signup failed: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } else {
      _showErrorSnackbar('Please fill all required fields correctly.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
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
                                      builder: (context) => LoginScreen()),
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
