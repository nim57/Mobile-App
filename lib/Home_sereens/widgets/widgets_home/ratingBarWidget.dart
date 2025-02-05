import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final double customerServiceRating;
  final double qualityOfServiceRating;

  const RatingBarWidget({super.key, 
    required this.customerServiceRating,
    required this.qualityOfServiceRating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRatingRow('Customer Service', customerServiceRating),
        const SizedBox(height: 16),
        _buildRatingRow('Quality of Service', qualityOfServiceRating),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: Colors.grey),
          ),
        ),
        Expanded(
          flex:5,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}