import 'package:cloud_firestore/cloud_firestore.dart';

import 'post_reply_model.dart';

class PostReplyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new reply
  Future<void> addReply(PostReplyModel reply) async {
    try {
      await _firestore.collection('postReplies').add(reply.toMap());
    } catch (e) {
      throw Exception('Failed to add reply: $e');
    }
  }

  // Update a reply
  Future<void> updateReply(PostReplyModel reply) async {
    try {
      await _firestore.collection('postReplies').doc(reply.id).update(reply.toMap());
    } catch (e) {
      throw Exception('Failed to update reply: $e');
    }
  }

  // Delete a reply
  Future<void> deleteReply(String replyId) async {
    try {
      await _firestore.collection('postReplies').doc(replyId).delete();
    } catch (e) {
      throw Exception('Failed to delete reply: $e');
    }
  }

  // Get replies for a comment
  Stream<List<PostReplyModel>> getRepliesForComment(String commentId) {
    return _firestore.collection('postReplies')
      .where('commentId', isEqualTo: commentId)
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => 
          PostReplyModel.fromMap(doc.data(), doc.id)).toList());
  }
}