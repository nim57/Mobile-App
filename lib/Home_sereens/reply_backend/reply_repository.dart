// reply_repository.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'reply_model.dart'; // Add this import

class ReplyRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addReply(ReplyModel reply) async {
    try {
      await _firestore.collection('replies').doc(reply.replyId).set({
        ...reply.toMap(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to save reply: ${e.toString()}';
    }
  }

  Future<String> uploadMedia(XFile file) async {
    try {
      // Use path.basename with file path
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final Reference ref = _storage.ref().child('replies/$fileName');
      final UploadTask task = ref.putFile(File(file.path));
      final TaskSnapshot snapshot = await task;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Media upload failed: ${e.toString()}';
    }
  }

  Stream<List<ReplyModel>> getReplies(String parentId) {
    return _firestore
        .collection('replies')
        .where('parentId', isEqualTo: parentId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReplyModel.fromMap(doc.data()))
            .toList());
  }

  Future<void> updateLikes(String replyId, int newCount) async {
    try {
      await _firestore.collection('replies').doc(replyId).update({
        'likes': newCount,
      });
    } catch (e) {
      throw 'Failed to update likes: ${e.toString()}';
    }
  }

  Future<void> updateDislikes(String replyId, int newCount) async {
    try {
      await _firestore.collection('replies').doc(replyId).update({
        'dislikes': newCount,
      });
    } catch (e) {
      throw 'Failed to update dislikes: ${e.toString()}';
    }
  }


   Future<void> deleteReply(String replyId) async {
    try {
      await _firestore.collection('replies').doc(replyId).delete();
    } catch (e) {
      throw 'Failed to delete reply: ${e.toString()}';
    }
  }

  Future<void> updateReply({
    required String replyId,
    required String text,
    required List<String> mediaUrls,
    required bool isVisible,
  }) async {
    try {
      await _firestore.collection('replies').doc(replyId).update({
        'text': text,
        'mediaUrls': mediaUrls,
        'isVisible': isVisible,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update reply: ${e.toString()}';
    }
  }



  static void initialize() {
    Get.put(ReplyRepository(), permanent: true);
  }


 Future<void> deleteRepliesByParentId(String parentId) async {
    try {
      final query = await _firestore
          .collection('replies')
          .where('parentId', isEqualTo: parentId)
          .get();

      final batch = _firestore.batch();
      for (final doc in query.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw 'Failed to delete replies: ${e.toString()}';
    }
  }
}