import 'package:flutter/material.dart';
import 'package:student_donation/pages/category.dart';

class MyCard extends StatelessWidget {
  final String title, description;
  final void Function()? onPressed;

  const MyCard({super.key, required this.title, required this.description, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 300,
      height: 250,
      decoration: const BoxDecoration(
          color: Colors.blueAccent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Title
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade900,
              ),
            ),

            //Button
            SizedBox(
              width: 400,
              height: 45,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
