import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodCategory extends StatefulWidget {
  const FoodCategory({Key? key}) : super(key: key);

  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  List<DocumentSnapshot> documents = [];

  // Fetch data from Firestore
  Future<void> fetchData() async {
    final QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("donation").get();

    setState(() {
      documents = querySnapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Categories"),
      ),
      body: Center(
        child: Column(
          children: [
            //Text("Centered text"),
            Expanded(
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data["donator name"]),
                    subtitle: Text(data["item name"]),// Replace "yourFieldName" with the actual field name in your Firestore document
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
