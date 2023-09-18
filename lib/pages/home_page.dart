import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_donation/components/my_card.dart';
import 'package:student_donation/pages/category.dart';
import 'package:student_donation/pages/donate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  void requestDonation(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const Category();
    }));
  }

  void makeDonate(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const Donate();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent.shade200,
        title: Text(user.email!),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                accountName: Text(
                  "Student Donation",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("Info@std.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    "S",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' Top Donators '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Request Donation '),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const Category();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 450,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(75), bottomLeft: Radius.circular(75)),
              ),
              child: const Center(
                child: Text(
                  "STUDENT DONATION",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: MyCard(
                        title: "Donate",
                        description:
                        "loreem adjhsdfbdavmsvbsdvbmsd hbvamshbvsvmshvsdvb", onPressed: makeDonate,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: MyCard(
                        title: "Request Donation",
                        description:
                        "loreem adjhsdfbdavmsvbsdvbmsd hbvamshbvsvmshvsdvb", onPressed: requestDonation,),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
