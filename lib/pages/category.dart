import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_donation/auth/main_page.dart';
import 'package:student_donation/components/category_card.dart';
import 'package:student_donation/pages/clothes_category.dart';
import 'package:student_donation/pages/food_category.dart';
import 'package:student_donation/pages/study_material.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs = [];

  //get DocIds
  Future<void> getDocIDs() async {
    await FirebaseFirestore.instance.collection("users").get().then(
          (snapshot) => snapshot.docs.forEach((element) {}),
    );
  }

  void foodCategory(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const FoodCategory();
    }));
  }
  void studyCategory(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const StudyMaterialCategory();
    }));
  }
  void clothesCategory(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const ClothesCategory();
    }));
  }

  @override
  void initState() {
    getDocIDs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade200,
        title: Text(user.email!),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const MainPage();
                }));
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
              title: const Text(' Top Donators '),
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
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  CategoryCard(
                      title: "Food",
                      img:
                      "food.png", onPressed: foodCategory),

                  CategoryCard(
                      title: "Study Material",
                      img:
                      "study.png", onPressed: studyCategory),

                  CategoryCard(
                      title: "Clothes",
                      img:
                      "clothes.png", onPressed: clothesCategory),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
