// rating_bar_widget.dart
import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final Map<String, double> reviewPoints;

  const RatingBarWidget({super.key, required this.reviewPoints});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var entry in reviewPoints.entries)
          Column(
            children: [
              _buildRatingRow(entry.key, entry.value),
              if (entry.key != reviewPoints.keys.last) 
                const SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  Widget _buildRatingRow(String label, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.normal,
              color: Colors.grey
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LinearProgressIndicator(
              value: rating / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 8,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${rating.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}