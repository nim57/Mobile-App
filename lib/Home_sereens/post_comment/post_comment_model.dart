import 'package:cloud_firestore/cloud_firestore.dart';

class PostCommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userProfilePic;
  final String content;
  final List<String>? mediaUrls;
  final List<String>? mediaTypes;
  final bool profileVisibility;
  final Timestamp timestamp;

  PostCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.content,
    this.mediaUrls,
    this.mediaTypes,
    required this.profileVisibility,
    required this.timestamp,
  });

  factory PostCommentModel.fromMap(Map<String, dynamic> map, String id) {
    return PostCommentModel(
      id: id,
      postId: map['postId'] ?? '',
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
      'postId': postId,
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