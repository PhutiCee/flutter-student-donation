import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_donation/pages/home_page.dart';

class Donate extends StatefulWidget {

  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _donatorName = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController =
  TextEditingController();


  String? _dropdownValue = "Select category";


  Future<void> submitDonation() async {
      //add user details
      addUserDetails(
        _donatorName.text.trim(),
        _itemNameController.text.trim(),
        _emailController.text.trim(),
        int.parse(_quantityController.text.trim()),
        _dropdownValue!.trim(),
      );
  }

  Future<void> addUserDetails(String donatorName, String itemName, String email,
      int quantity, String category) async {
    await FirebaseFirestore.instance.collection("donation").add({
      'donator name': donatorName,
      'item name': itemName,
      'email': email,
      'quantity': quantity,
      'category': category,
    });
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
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _donatorName.dispose();
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Banner Image

                  // Welcome Message
                  const Text(
                    "What would you like to Donate?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Donator Name TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _donatorName,
                      validator: _validateInputs,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Donator's Name",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Item Name TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _itemNameController,
                      validator: _validateInputs,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Item Name",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: DropdownButtonFormField<String>(
                      value: _dropdownValue,
                      validator: (value) {
                        if (value == null || value.isEmpty || value == 'Select category') {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      },
                      items: <String>['Select category', 'Food', 'Study Material', 'Clothes']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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

                  // Quantity TextInput
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _quantityController,
                      validator: _validateInputs,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "Quantity",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: 500,
                      height: 45,
                      child: ElevatedButton(
                        // onPressed: () {
                        //   setState(() {
                        //     _emailError = _validateEmail(_emailController.text);
                        //     _inputError = _validateInputs(_donatorName.text);
                        //
                        //     if (_formKey.currentState!.validate()) {
                        //       submitDonation();
                        //     }
                        //   });
                        // },

                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitDonation();
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const HomePage();
                            }));
                            //print(_dropdownValue);
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
                          "Submit",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
