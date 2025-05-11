// badge_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'badge_model.dart';

class BadgeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateBadge(Badge_item badge) async {
    try {
      await _firestore.collection('badges')
        .doc(badge.itemId)
        .set(badge.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to update badge: ${e.toString()}';
    }
  }

  Future<Badge_item?> getBadgeByItem(String itemId) async {
    final doc = await _firestore.collection('badges').doc(itemId).get();
    return doc.exists ? Badge_item.fromFirestore(doc) : null;
  }

  Stream<Badge_item?> streamBadgeByItem(String itemId) {
    return _firestore.collection('badges')
      .doc(itemId)
      .snapshots()
      .map((snap) => snap.exists ? Badge_item.fromFirestore(snap) : null);
  }
}