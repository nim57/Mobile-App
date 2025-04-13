// comment_repository.dart
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
        .handleError((e) {
          if (e is FirebaseException && e.code == 'failed-precondition') {
            throw 'Please create the Firestore index first: ${e.message}';
          }
          throw 'Failed to load comments: ${e.toString()}';
        })
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromMap(doc.data()))
            .toList());
  } catch (e) {
    throw 'Comments Error: ${e.toString()}';
  }
}

  Future<void> addComment(CommentModel comment) async {
    try {
      await _firestore
          .collection('comments')
          .doc(comment.commentId)
          .set(comment.toMap());
    } catch (e) {
      throw 'Failed to add comment: $e';
    }
  }


  
}