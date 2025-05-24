// badge_controller.dart
import 'package:get/get.dart';
import 'badge_model.dart';
import 'badge_repository.dart';

class BadgeController extends GetxController {
  final BadgeRepository _repository = BadgeRepository();
  final Rx<Badge_item?> badge = Rx<Badge_item?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Stream<Badge_item?> streamBadge(String itemId) {
    return _repository.streamBadgeByItem(itemId);
  }

  Future<void> loadBadge(String itemId) async {
    try {
      isLoading(true);
      error('');
      final Badge_item? data = await _repository.getBadgeByItem(itemId);
      badge.value = data ?? _defaultBadge(itemId);
    } catch (e) {
      error('Failed to load badge: ${e.toString()}');
      badge.value = _defaultBadge(itemId);
    } finally {
      isLoading(false);
    }
  }

  Badge_item _defaultBadge(String itemId) => Badge_item(
        itemId: itemId,
        itemName: '',
        categoryId: '',
        mapLocation: '',
        quinceUsersCount: 0,
        totalReviews: 0,
        reviewPoints: {},
        badReviewPercentage: 0,
        lastUpdated: DateTime.now(),
      );
}