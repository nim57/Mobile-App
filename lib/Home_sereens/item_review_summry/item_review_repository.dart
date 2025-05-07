// item_review_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'item_review_summary_model.dart';

class ItemReviewRepository extends GetxController {
  static ItemReviewRepository get instance => Get.put(ItemReviewRepository(),
      tag: 'ItemReviewRepository', permanent: true);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveReviewSummary(ItemReviewSummary summary) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('itemReviews').doc(summary.itemId);

        transaction.set(docRef, summary.toFirestore(), SetOptions(merge: true));

        // Update category summary
        final categoryRef =
            _firestore.collection('categoryReviews').doc(summary.categoryId);
        transaction.update(categoryRef, {
          'items': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw 'Firestore error: ${e.code} - ${e.message}';
    } catch (e) {
      throw 'Failed to save review summary: ${e.toString()}';
    }
  }

  Future<ItemReviewSummary?> getSummaryByItem(String itemId) async {
    try {
      final doc = await _firestore.collection('itemReviews').doc(itemId).get();
      return doc.exists ? ItemReviewSummary.fromFirestore(doc) : null;
    } on FirebaseException catch (e) {
      throw 'Firestore error: ${e.code} - ${e.message}';
    } catch (e) {
      throw 'Failed to fetch summary: ${e.toString()}';
    }
  }

  Stream<ItemReviewSummary> streamSummary(String itemId) {
    return _firestore
        .collection('itemReviews')
        .doc(itemId)
        .snapshots()
        .map((snapshot) => ItemReviewSummary.fromFirestore(snapshot));
  }
}
