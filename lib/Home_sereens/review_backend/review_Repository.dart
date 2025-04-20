// review_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'review_model.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Stream<List<ReviewModel>> getReviewsByItem(String itemId) {
  try {
    return _firestore
        .collection('reviews')
        .where('itemId', isEqualTo: itemId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromSnapshot(doc))
            .toList());
  } catch (e) {
    throw 'Review Error: ${e.toString()}';
  }
}

  Future<String> getCategoryName(String categoryId) async {
    final doc = await _firestore.collection('categories').doc(categoryId).get();
    return doc['name'] ?? 'Unknown Category';
  }

  Future<String> getItemName(String itemId) async {
    final doc = await _firestore.collection('items').doc(itemId).get();
    return doc['name'] ?? 'Unknown Item';
  }

  Future<void> addReview(ReviewModel review) async {
    await _firestore.collection('reviews').doc(review.reviewId).set({
      'userId': review.userId,
      'itemId': review.itemId,
      'itemName': review.itemName,
      'categoryId': review.categoryId,
      'ratings': review.ratings,
      'tags': review.tags,
      'title': review.title,
      'comment': review.comment,
      'isVisible': review.isVisible,
      'username': review.username,
      'userProfile': review.userProfile,
      'timestamp': review.timestamp,
    });
  }


   Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      throw 'Failed to delete review: ${e.toString()}';
    }
  }
}
