import 'package:flutter/material.dart';

class CustomRatingBar extends StatelessWidget {
  final String title;
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const CustomRatingBar({
    super.key,
    required this.title,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '${rating.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Slider(
          value: rating,
          min: 0,
          max: 100,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey.shade300,
          onChanged: onRatingChanged,
        ),
      ],
    );
  }
}
