import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CommentModel>> getCommentsStream(String itemId) {
    try {
      return _firestore
          .collection('comments')
          .where('itemId', isEqualTo: itemId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .handleError((error) {
        print('🔥 FIRESTORE ERROR: $error');
        throw error;
      }).map((snapshot) {
        print('📥 Received ${snapshot.docs.length} comments');

        return snapshot.docs.map((doc) {
          final data = doc.data();
          print('📄 Document ${doc.id}: ${data.toString()}');

          return CommentModel.fromMap(data);
        }).toList();
      });
    } catch (e) {
      print('❌ CRITICAL ERROR: $e');
      rethrow;
    }
  }

  Future<void> addComment(CommentModel comment) async {
    try {
      print('Adding comment: ${comment.text}');
      await _firestore
          .collection('comments')
          .doc(comment.commentId)
          .set(comment.toMap());
      print('Comment added successfully!');
    } catch (e) {
      print('Error adding comment: $e');
      throw 'Failed to add comment: $e';
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      print('Deleting comment: $commentId');
      await _firestore.collection('comments').doc(commentId).delete();
      print('Comment deleted successfully!');
    } catch (e) {
      print('Error deleting comment: $e');
      throw 'Failed to delete comment: ${e.toString()}';
    }
  }
}
