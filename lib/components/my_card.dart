import 'package:flutter/material.dart';
import 'package:student_donation/pages/category.dart';

class MyCard extends StatelessWidget {
  final String title, description;
  final void Function()? onPressed;

  const MyCard({super.key, required this.title, required this.description, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 205,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade800.withOpacity(0.3),
                spreadRadius: 2,
                offset: const Offset(0, 4)),
          ]),
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
              ),
            ),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            //Button
            SizedBox(
              width: 400,
              height: 45,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
