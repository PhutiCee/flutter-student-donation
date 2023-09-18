import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_donation/pages/reset_password.dart';

import '../auth/AuthPage.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // In _LoginPageState
  Future<void> signIn() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Successful login, navigate to the appropriate page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return FirebaseAuth.instance.currentUser != null ? const HomePage() : const AuthPage();
      }));
    } catch (error) {
      print(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // You can add more password validation logic here if needed
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  const Icon(
                    Icons.phone_android,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Welcome Message
                  const Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),

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

                  //forget password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ResetPassword();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: 500,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signIn();
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
                          "LOGIN",
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
                        const Text("Don't have an account?"),
                        GestureDetector(
                          onTap: widget.showRegisterPage,
                          child: const Text(
                            " Sign Up",
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
