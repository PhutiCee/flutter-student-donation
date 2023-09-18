import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title, img;
  final void Function()? onPressed;

  const CategoryCard({super.key, required this.title, required this.img, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          //width: 330,
          height: 300,
          decoration: const BoxDecoration(
              color: Colors.blueAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Image.asset("lib/images/$img")),


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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
