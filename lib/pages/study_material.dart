import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class StudyMaterialCategory extends StatefulWidget {
  const StudyMaterialCategory({Key? key}) : super(key: key);

  @override
  State<StudyMaterialCategory> createState() => _StudyMaterialCategoryState();
}

class _StudyMaterialCategoryState extends State<StudyMaterialCategory> {
  List<DocumentSnapshot> documents = [];

  final user = FirebaseAuth.instance.currentUser!;
  bool isLoading = true;
  bool isFunded = false;

  // Fetch data from FireStore
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("donation")
        .where("category", isEqualTo: "Study Material")
        .get();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          isFunded = userData["isFunded"] ?? false;
        });
      }
    });

    setState(() {
      documents = querySnapshot.docs;
      isLoading = false;
    });
  }

  // Function to show an AlertDialog with a message
  Future<void> _showAlertDialog(String message, Function onOKPressed) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOKPressed();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade200,
        title: const Text("Study Material Categories"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Expanded(
              child: isLoading
                  ? Container(
                  height: 1,
                  width: 200,
                  margin: const EdgeInsets.symmetric(vertical: 200),
                  child: const CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: isFunded
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You cannot request a donation, rather donate for those who are in need",
                        style: TextStyle(
                            color: Colors.red, fontSize: 18),
                      ),
                      const SizedBox(height: 50),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: const Center(
                            child: Text(
                              "Donate ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data = documents[index].data()
                    as Map<String, dynamic>;
                    final quantity = data["quantity"] ?? 0;

                    if (quantity > 0) {
                      return Card(
                        color: Colors.blueAccent,
                        elevation: 3,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 400,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.blueAccent.shade400,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Donator Name: ${data["donator name"]}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    Text(
                                      "Item Name: ${data["item name"]}",
                                      style:
                                      const TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10),
                                width: 200,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final data =
                                    documents[index].data()
                                    as Map<String, dynamic>;

                                    final smtpServer = gmail(
                                        'tsptshepo382@gmail.com',
                                        'yqwhjsicctwblvgm');

                                    final message = Message()
                                      ..from = Address(
                                          'studentdonation@gmail.com')
                                      ..recipients.add(user.email!)
                                      ..subject = 'Donation Request'
                                      ..text =
                                          'You can collect the donation at student center with ref ${data["donator name"]}-${data["quantity"]} ';

                                    try {
                                      final sendReport = await send(
                                          message, smtpServer);
                                      print(
                                          'Message sent: ${sendReport.toString()}');

                                      final int currentQuantity =
                                      data["quantity"];
                                      await FirebaseFirestore
                                          .instance
                                          .collection("donation")
                                          .doc(documents[index].id)
                                          .update({
                                        "quantity":
                                        currentQuantity - 1
                                      });

                                      _showAlertDialog(
                                          'Email sent! Please check your email for details. ',
                                              () {
                                            fetchData();
                                          });
                                    } catch (e) {
                                      print(
                                          'Error sending email: $e');
                                      _showAlertDialog(
                                          'Failed to send email.',
                                              () {});
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Request",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // If quantity is zero, return an empty container to skip rendering this item
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
