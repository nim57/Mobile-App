import 'package:flutter/material.dart';

class Item_tile2 extends StatelessWidget {
  const Item_tile2({
    super.key, this.action, required this.logo,
  });

  final VoidCallback? action;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white, // white background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 2, // Spread radius
              blurRadius: 8,  // Blur radius
              offset: const Offset(0, 4), // Shadow offset (horizontal, vertical)
            ),
          ],
        ),
        child: Column(
          children: [
            // Bank Icon
            Image.asset(
              logo, // Path to your bank icon image
              width: 180, // Adjust size as needed
              height: 140,
            ),
          ],
        ),
      ),
    );
  }
}
