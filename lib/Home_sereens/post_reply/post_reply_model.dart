import 'package:cloud_firestore/cloud_firestore.dart';

class PostReplyModel {
  final String id;
  final String commentId;
  final String userId;
  final String userName;
  final String userProfilePic;
  final String content;
  final List<String>? mediaUrls;
  final List<String>? mediaTypes;
  final bool profileVisibility;
  final Timestamp timestamp;

  PostReplyModel({
    required this.id,
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.content,
    this.mediaUrls,
    this.mediaTypes,
    required this.profileVisibility,
    required this.timestamp,
  });

  factory PostReplyModel.fromMap(Map<String, dynamic> map, String id) {
    return PostReplyModel(
      id: id,
      commentId: map['commentId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userProfilePic: map['userProfilePic'] ?? '',
      content: map['content'] ?? '',
      mediaUrls: map['mediaUrls'] != null ? List<String>.from(map['mediaUrls']) : null,
      mediaTypes: map['mediaTypes'] != null ? List<String>.from(map['mediaTypes']) : null,
      profileVisibility: map['profileVisibility'] ?? true,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userProfilePic': userProfilePic,
      'content': content,
      'mediaUrls': mediaUrls,
      'mediaTypes': mediaTypes,
      'profileVisibility': profileVisibility,
      'timestamp': timestamp,
    };
  }
}