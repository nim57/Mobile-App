// badge_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Badge_item {
  final String itemId;
  final String itemName;
  final String categoryId;
  final String mapLocation;
  final int quinceUsersCount;
  final int totalReviews;
  final Map<String, double> reviewPoints;
  final double badReviewPercentage;
  final DateTime lastUpdated;

  Badge_item({
    required this.itemId,
    required this.itemName,
    required this.categoryId,
    required this.mapLocation,
    required this.quinceUsersCount,
    required this.totalReviews,
    required this.reviewPoints,
    required this.badReviewPercentage,
    required this.lastUpdated,
  });

  factory Badge_item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Badge_item(
      itemId: doc.id,
      itemName: data['itemName'] ?? '',
      categoryId: data['categoryId'] ?? '',
      mapLocation: data['mapLocation'] ?? '',
      quinceUsersCount: data['quinceUsersCount'] ?? 0,
      totalReviews: data['totalReviews'] ?? 0,
      reviewPoints: Map<String, double>.from(data['reviewPoints'] ?? {}),
      badReviewPercentage: (data['badReviewPercentage'] ?? 0.0).toDouble(),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'categoryId': categoryId,
      'mapLocation': mapLocation,
      'quinceUsersCount': quinceUsersCount,
      'totalReviews': totalReviews,
      'reviewPoints': reviewPoints,
      'badReviewPercentage': badReviewPercentage,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}