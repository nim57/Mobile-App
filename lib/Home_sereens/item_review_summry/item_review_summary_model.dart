// item_review_summary_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemReviewSummary {
  final String itemId;
  final String categoryId;
  final String itemName;
  final int totalReviews;
  final Map<String, double> reviewPoints;
  final Timestamp lastUpdated;

  ItemReviewSummary({
    required this.itemId,
    required this.categoryId,
    required this.itemName,
    required this.totalReviews,
    required this.reviewPoints,
    required this.lastUpdated,
  });

  factory ItemReviewSummary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemReviewSummary(
      itemId: doc.id,
      categoryId: data['categoryId'] ?? '',
      itemName: data['itemName'] ?? '',
      totalReviews: data['totalReviews'] ?? 0,
      reviewPoints: _convertReviewPoints(data['reviewPoints']),
      lastUpdated: data['lastUpdated'] as Timestamp,
    );
  }

  static Map<String, double> _convertReviewPoints(dynamic points) {
    final Map<String, double> converted = {};
    (points as Map).forEach((key, value) {
      converted[key.toString()] = (value as num).toDouble();
    });
    return converted;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'itemName': itemName,
      'totalReviews': totalReviews,
      'reviewPoints': reviewPoints,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return 'ItemReviewSummary{itemId: $itemId, categoryId: $categoryId, totalReviews: $totalReviews}';
  }
}