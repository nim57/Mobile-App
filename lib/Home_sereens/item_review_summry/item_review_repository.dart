// item_review_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_project_123/Home_sereens/item_review_summry/item_review_summary_model.dart';

class ItemReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateSummary(ItemReviewSummary summary) async {
    await _firestore.collection('itemReviews')
      .doc(summary.itemId)
      .set(summary.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteSummary(String itemId) async {
    await _firestore.collection('itemReviews').doc(itemId).delete();
  }

  Future<ItemReviewSummary?> getSummaryByItem(String itemId) async {
    final doc = await _firestore.collection('itemReviews').doc(itemId).get();
    return doc.exists ? ItemReviewSummary.fromFirestore(doc) : null;
  }

  Stream<ItemReviewSummary?> streamSummaryByItem(String itemId) {
    return _firestore.collection('itemReviews')
      .doc(itemId)
      .snapshots()
      .map((snap) => snap.exists ? ItemReviewSummary.fromFirestore(snap) : null);
  }
}