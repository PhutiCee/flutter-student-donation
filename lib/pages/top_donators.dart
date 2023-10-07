import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopDonator extends StatefulWidget {
  const TopDonator({Key? key});

  @override
  State<TopDonator> createState() => _TopDonatorState();
}

class _TopDonatorState extends State<TopDonator> {
  // Define a list to store top donator data
  List<Map<String, dynamic>> topDonatorData = [];

  // Fetch top donator data from Firestore
  Future<void> fetchTopDonators() async {
    final donationCollection = FirebaseFirestore.instance.collection("donation");
    final querySnapshot = await donationCollection.get();

    // Create a map to count unique emails
    final emailCountMap = <String, int>{};
    querySnapshot.docs.forEach((doc) {
      final email = doc.get("email");
      emailCountMap[email] = (emailCountMap[email] ?? 0) + 1;
    });

    // Sort the email count map in descending order
    final sortedEmails = emailCountMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Get the top 2 emails
    final topEmails = sortedEmails.take(2).map((entry) => entry.key).toList();

    // Fetch the top donators based on the top emails
    final topDonatorQuery = await donationCollection
        .where("email", whereIn: topEmails)
        .get();

    // Create a set to keep track of unique donator names
    final uniqueDonatorNames = <String>{};

    // Extract data and add it to the list, ensuring donator names are unique
    topDonatorQuery.docs.forEach((doc) {
      final donatorName = doc.get("donator name");
      final itemName = doc.get("item name");
      final email = doc.get("email");
      final quantity = doc.get("quantity");
      final category = doc.get("category");

      if (!uniqueDonatorNames.contains(donatorName)) {
        topDonatorData.add({
          "donator name": donatorName,
          "item name": itemName,
          "email": email,
          "quantity": quantity,
          "category": category,
        });
        uniqueDonatorNames.add(donatorName);
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    fetchTopDonators();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Donators"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: topDonatorData.length,
                itemBuilder: (context, index) {
                  final donator = topDonatorData[index];

                  return Card(
                    color: Colors.blueAccent,
                    elevation: 3,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                  "Donator Name: ${donator['donator name']}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "Email: ${donator['email']}",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
