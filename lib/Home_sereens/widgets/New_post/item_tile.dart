import 'package:flutter/material.dart';

class Item_tile extends StatelessWidget {
  const Item_tile({
    super.key,
    this.action,
    required this.image,
    required this.name,
  });

  final VoidCallback? action;
  final String image;
  final String name;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white60, // Transparent background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bank Icon
            Image.asset(
              image, // Path to your bank icon image
              width: 170, // Adjust size as needed
              height: 170,
            ),
            const SizedBox(height: 5),
            // Card Text
            Text(
              name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Adjust text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}