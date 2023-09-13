import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSendingResetEmail = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';

    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetPassword() async {
    setState(() {
      _isSendingResetEmail = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("A password reset link has been sent to your email."),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Error: ${e.message}"),
          );
        },
      );
    } finally {
      setState(() {
        _isSendingResetEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Enter your email, and we will send you a password reset link",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),

            // TextFormField For Forgot Password with real-time validation
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter Email here",
                fillColor: Colors.grey.shade200,
                filled: true,
                errorText: _validateEmail(_emailController.text.trim()), // Validation here
              ),
            ),
            const SizedBox(height: 20),

            // Reset Button
            SizedBox(
              width: 500,
              height: 45,
              child: ElevatedButton(
                onPressed: _isSendingResetEmail ? null : sendResetPassword,
                child: Text(_isSendingResetEmail ? "Sending..." : "Reset"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
