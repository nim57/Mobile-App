// badge_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'badge_model.dart';

class BadgeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Predefined badge configurations
  static const Map<String, Map<String, dynamic>> badgeConditions = {
    'Legend Seller': {
      'quinceUsers': 15000,
      'reviewThreshold': 95.0,
      'negativeThreshold': 10.0,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/echo-review-system.firebasestorage.app/o/badges%2Flegend.png?alt=media&token=b82eeb72-ccfc-4041-9e83-a820dfcb61a8',
    },
    'Elite Seller': {
      'quinceUsers': 10000,
      'reviewThreshold': 75.0,
      'negativeThreshold': 40.0,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/echo-review-system.firebasestorage.app/o/badges%2Felite.png?alt=media&token=992100d0-4283-430e-a37e-4e2fe287a1b4',
    },
    'Pro Seller': {
      'quinceUsers': 5000,
      'reviewThreshold': 65.0,
      'negativeThreshold': 50.0,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/echo-review-system.firebasestorage.app/o/badges%2Fpro.png?alt=media&token=bb9548cd-16a3-42fd-ad54-98d7bb606c8a',
    },
    'Seller': {
      'quinceUsers': 1000,
      'reviewThreshold': 50.0,
      'negativeThreshold': 60.0,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/echo-review-system.firebasestorage.app/o/badges%2Fbadges.png?alt=media&token=12973255-9a5f-4616-8b55-75f7430b6b8b',
    },
  };

  Future<void> createOrUpdateBadge(Badge_item badge) async {
    try {
      await _firestore
          .collection('badges')
          .doc(badge.itemId)
          .set(badge.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to update badge: ${e.toString()}';
    }
  }

  Future<Badge_item?> getBadgeByItem(String itemId) async {
    try {
      final doc = await _firestore.collection('badges').doc(itemId).get();
      return doc.exists ? Badge_item.fromFirestore(doc) : null;
    } catch (e) {
      throw 'Failed to fetch badge: ${e.toString()}';
    }
  }

  Stream<Badge_item?> streamBadgeByItem(String itemId) {
    return _firestore
        .collection('badges')
        .doc(itemId)
        .snapshots()
        .handleError((e) => throw 'Stream error: ${e.toString()}')
        .map((snap) => snap.exists ? Badge_item.fromFirestore(snap) : null);
  }

  Future<void> evaluateAndUpdateBadge(String itemId) async {
    try {
      final badgeItem = await getBadgeByItem(itemId);
      if (badgeItem == null) throw 'Item not found';

      // Calculate average review points
      final averageReview = badgeItem.reviewPoints.values.isEmpty
          ? 0.0
          : badgeItem.reviewPoints.values.reduce((a, b) => a + b) /
              badgeItem.reviewPoints.values.length;

      // Determine earned badge
      String earnedBadge = 'Registered Shop';
      String earnedImage = 'https://example.com/default_badge.png';

      // Check conditions in descending order (highest first)
      for (final entry in badgeConditions.entries) {
        if (badgeItem.quinceUsersCount >= entry.value['quinceUsers']! &&
            averageReview >= entry.value['reviewThreshold']! &&
            badgeItem.badReviewPercentage <=
                entry.value['negativeThreshold']!) {
          earnedBadge = entry.key;
          earnedImage = entry.value['imageUrl']!;
          break;
        }
      }

      // Update badge information
      final updatedBadge = Badge_item(
        itemId: badgeItem.itemId,
        itemName: badgeItem.itemName,
        categoryId: badgeItem.categoryId,
        mapLocation: badgeItem.mapLocation,
        quinceUsersCount: badgeItem.quinceUsersCount,
        totalReviews: badgeItem.totalReviews,
        reviewPoints: badgeItem.reviewPoints,
        badReviewPercentage: badgeItem.badReviewPercentage,
        lastUpdated: DateTime.now(),
        badgeName: earnedBadge,
        badgeImageUrl: earnedImage,
      );

      await createOrUpdateBadge(updatedBadge);
    } catch (e) {
      throw 'Badge evaluation failed: ${e.toString()}';
    }
  }

  
}
