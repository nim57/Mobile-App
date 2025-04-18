// reply_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  final String replyId;
  final String parentId;
  final String itemId;
  final String authorId;
  final String authorName;
  final String authorEmail;
  final String prefecture;
  final String text;
  final List<String> mediaUrls;
  final List<String> emojis;
  final DateTime timestamp;
  final bool isVisible;
  final int likes;
  final int dislikes;

  ReplyModel({
    required this.replyId,
    required this.parentId,
    required this.itemId,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.prefecture,
    required this.text,
    required this.mediaUrls,
    required this.emojis,
    required this.timestamp,
    required this.isVisible,
    required this.likes,
    required this.dislikes,
  });

  Map<String, dynamic> toMap() {
    return {
      'replyId': replyId,
      'parentId': parentId,
      'itemId': itemId,
      'authorId': authorId,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'prefecture': prefecture,
      'text': text,
      'mediaUrls': mediaUrls,
      'emojis': emojis,
      'timestamp': timestamp,
      'isVisible': isVisible,
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    return ReplyModel(
      replyId: map['replyId'],
      parentId: map['parentId'],
      itemId: map['itemId'],
      authorId: map['authorId'],
      authorName: map['authorName'],
      authorEmail: map['authorEmail'],
      prefecture: map['prefecture'],
      text: map['text'],
      mediaUrls: List<String>.from(map['mediaUrls']),
      emojis: List<String>.from(map['emojis']),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isVisible: map['isVisible'],
      likes: map['likes'] ?? 0,
      dislikes: map['dislikes'] ?? 0,
    );
  }
}