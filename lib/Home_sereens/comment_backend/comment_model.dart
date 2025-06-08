import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String userId;
  final String itemId;
  final String text;
  final bool isVisible;
  final String username;
  final String userProfile;
  final List<String> tags;
  final String title;
  final Timestamp timestamp;
  
  // Sentiment analysis fields
  final String? sentiment; // 'positive', 'negative', 'error', or null
  final Timestamp? analyzedAt;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.itemId,
    required this.text,
    required this.isVisible,
    required this.username,
    required this.userProfile,
    required this.tags,
    required this.title,
    required this.timestamp,
    this.sentiment,        // Nullable
    this.analyzedAt,       // Nullable
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'itemId': itemId,
      'text': text,
      'isVisible': isVisible,
      'username': username,
      'userProfile': userProfile,
      'tags': tags,
      'title': title,
      'timestamp': timestamp,
      'sentiment': sentiment,      // Added
      'analyzedAt': analyzedAt,     // Added
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'] ?? '',
      userId: map['userId'] ?? '',
      itemId: map['itemId'] ?? '',
      text: map['text'] ?? '',
      isVisible: map['isVisible'] ?? true,
      username: map['username'] ?? 'Anonymous',
      userProfile: map['userProfile'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      title: map['title'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?) ?? Timestamp.now(),
      sentiment: map['sentiment'],             // Added
      analyzedAt: map['analyzedAt'] as Timestamp?, // Added
    );
  }
}