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
      appBar: AppBar(
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
                color: Colors.green,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
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
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' My Work '),
              onTap: () {
                //Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' Go Premium '),
              onTap: () {
                //Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                // Navigator.pop(context);
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
      ), //Drawer
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Welcome!",
                style: TextStyle(fontSize: 35),
              ),
            ),
            const SizedBox(height: 10),
            MyCard(
                title: "Donate",
                description:
                    "loreem adjhsdfbdavmsvbsdvbmsd hbvamshbvsvmshvsdvb", onPressed: makeDonate,),
            const SizedBox(height: 15),
            MyCard(
                title: "Request Donation",
                description:
                    "loreem adjhsdfbdavmsvbsdvbmsd hbvamshbvsvmshvsdvb", onPressed: requestDonation,),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
