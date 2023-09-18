import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/AuthPage.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _studentNumberController =
      TextEditingController();
  late final bool isFunded;
  bool _isLoading = false;

  Future<void> signUp() async {
    if (confirmedPassword()) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      try {
        // Create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Add user details
        await addUserDetails(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          int.parse(_studentNumberController.text.trim()),
        );

        // Successful signup, navigate to the appropriate page
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return FirebaseAuth.instance.currentUser != null ? const HomePage() : const AuthPage();
        }));
      } catch (error) {
        // Handle any errors during sign-up
        print(error);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


  Future<void> addUserDetails(String firstname, String lastname, String email,
      int studentNumber) async {
    bool isFunded = (studentNumber % 2 == 0);

    await FirebaseFirestore.instance.collection("users").add({
      'first name': firstname,
      'last name': lastname,
      'email': email,
      'student number': studentNumber,
      'isFunded': isFunded,
    });
  }

  bool confirmedPassword() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  String? _validateEmail(String? value) {
    // if (_emailError != null) {
    //   return _emailError;
    // }
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';

    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateInputs(String? value) {
    // if (_inputError != null) {
    //   return _inputError;
    // }
    if (value == null || value.isEmpty) {
      return 'Please fill the field';
    }
    // You can add more password validation logic here if needed
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // You can add more password validation logic here if needed
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    // You can add more password validation logic here if needed
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _studentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Banner Image

                  // Welcome Message
                  const Text(
                    "REGISTER",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Welcome Message
                  const Text(
                    "Register with your details!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // FirstName TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _firstNameController,
                      validator: _validateInputs,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "First Name",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // LastName TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _lastNameController,
                      validator: _validateInputs,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "LastName",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _emailController,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Email",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _studentNumberController,
                      validator: _validateInputs,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Student Number",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Password",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Confirm password",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Register Button with progress indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: 500,
                      height: 45,
                      child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  signUp();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Not a member Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Have an account?"),
                        GestureDetector(
                          onTap: widget.showLoginPage,
                          child: const Text(
                            " Login",
                            style: TextStyle(color: Colors.blue),
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
      ),
    );
  }
}
