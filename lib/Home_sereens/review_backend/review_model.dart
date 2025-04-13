// models/review_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewId;
  final String userId;
  final String itemId;
  final String itemName;
  final String categoryId;
  final Map<String, double> ratings;
  final List<String> tags;
  final String title;
  final String comment;
  final bool isVisible;
  final String username;
  final String userProfile;
  final Timestamp timestamp;

  ReviewModel({
    required this.reviewId,
    required this.userId,
    required this.itemId,
    required this.itemName,
    required this.categoryId,
    required this.ratings,
    required this.tags,
    required this.title,
    required this.comment,
    required this.isVisible,
    required this.username,
    required this.userProfile,
    required this.timestamp,
  });

  factory ReviewModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ReviewModel(
      reviewId: snapshot.id,
      userId: data['userId'] ?? '',
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      categoryId: data['categoryId'] ?? '',
      ratings: _convertRatings(data['ratings']),
      tags: List<String>.from(data['tags'] ?? []),
      title: data['title'] ?? '',
      comment: data['comment'] ?? '',
      isVisible: data['isVisible'] ?? true,
      username: data['username'] ?? '',
      userProfile: data['userProfile'] ?? '',
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  static Map<String, double> _convertRatings(dynamic ratings) {
    final Map<String, double> converted = {};
    (ratings as Map).forEach((key, value) {
      converted[key.toString()] = value.toDouble();
    });
    return converted;
  }
}