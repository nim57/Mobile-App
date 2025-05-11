// item_review_summary_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemReviewSummary {
  final String itemId;
  final String itemName;
  final String categoryId;
  final int quinceUsersCount;
  final Map<String, double> reviewPoints;
  final DateTime lastUpdated;

  ItemReviewSummary({
    required this.itemId,
    required this.itemName,
    required this.categoryId,
    required this.quinceUsersCount,
    required this.reviewPoints,
    required this.lastUpdated,
  });

  factory ItemReviewSummary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemReviewSummary(
      itemId: doc.id,
      itemName: data['itemName'] ?? '',
      categoryId: data['categoryId'] ?? '',
      quinceUsersCount: data['quinceUsersCount'] ?? 0,
      reviewPoints: Map<String, double>.from(data['reviewPoints'] ?? {}),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'categoryId': categoryId,
      'quinceUsersCount': quinceUsersCount,
      'reviewPoints': reviewPoints,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}