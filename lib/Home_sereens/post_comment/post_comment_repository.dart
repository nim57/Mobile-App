import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_manager/photo_manager.dart';

import 'post_comment_model.dart';

class PostCommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Add a new comment
  Future<void> addComment(PostCommentModel comment) async {
    try {
      await _firestore.collection('postComments').add(comment.toMap());
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // Update a comment
  Future<void> updateComment(PostCommentModel comment) async {
    try {
      await _firestore.collection('postComments').doc(comment.id).update(comment.toMap());
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  // Delete a comment and its replies
  Future<void> deleteComment(String commentId) async {
    try {
      // Delete comment
      await _firestore.collection('postComments').doc(commentId).delete();
      
      // Delete all replies to this comment
      final replies = await _firestore.collection('postReplies')
          .where('commentId', isEqualTo: commentId)
          .get();
      
      for (final doc in replies.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  // Get comments for a post
  Stream<List<PostCommentModel>> getCommentsForPost(String postId) {
    return _firestore.collection('postComments')
      .where('postId', isEqualTo: postId)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => 
          PostCommentModel.fromMap(doc.data(), doc.id)).toList());
  }

  // Upload media files for comment/reply
  Future<List<String>> uploadMediaFiles(List<AssetEntity> mediaFiles) async {
    List<String> urls = [];
    for (var media in mediaFiles) {
      final file = await media.file;
      if (file == null) continue;
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = media.type == AssetType.video ? 'mp4' : 'jpg';
      final fileName = 'comment_media_$timestamp.${media.id}.$extension';
      
      final ref = _storage.ref().child('comments/media/$fileName');
      await ref.putFile(File(file.path));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  // Get media types
  List<String> getMediaTypes(List<AssetEntity> mediaFiles) {
    return mediaFiles.map((media) => 
        media.type == AssetType.video ? 'video' : 'image').toList();
  }
}