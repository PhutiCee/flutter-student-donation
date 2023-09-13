import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title, img;
  final void Function()? onPressed;

  const CategoryCard({super.key, required this.title, required this.img, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 300,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade800.withOpacity(0.3), spreadRadius: 2, offset: const Offset(0, 4)),
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Image.asset("lib/images/$img")),
            //Title
            // Text(
            //   title.toUpperCase(),
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),

            //

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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
