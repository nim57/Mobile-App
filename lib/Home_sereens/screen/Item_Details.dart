import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/constants/colors.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../badge_system/badge_controller.dart';
import '../badge_system/badges_screen.dart';
import '../item_backend/item_controller.dart';
import '../item_backend/item_model.dart';
import '../review_backend/review_controler.dart';
import '../widgets/widgets_home/ratingBarWidget.dart';
import 'Comment&ReviewScreen.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.put(ItemController());
    final ReviewController reviewController = Get.put(ReviewController());
    final String? itemId = Get.arguments as String?;
    final BadgeController badgeController = Get.put(BadgeController());

    if (itemId == null) {
      return Scaffold(
        appBar: const EAppBar(titlt: Text('Item Details'), showBackArrow: true),
        body: const Center(child: Text('Item ID not provided')),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadItemForEdit(itemId);
      controller.loadUserEngagementData(itemId);
      badgeController.loadBadge(itemId);
    });

    return Scaffold(
      appBar: const EAppBar(titlt: Text('Item Details'), showBackArrow: true),
      body: Obx(() {
        if (controller.itemLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final Item? item = controller.selectedItem.value.id.isNotEmpty
            ? controller.selectedItem.value
            : null;

        if (item == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Item not found'),
                ElevatedButton(
                  onPressed: () => controller.loadItemForEdit(itemId),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        // Add post-frame callback for fetching reviews
        WidgetsBinding.instance.addPostFrameCallback((_) {
          reviewController.fetchReviews(item.id, item.categoryId);
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(item, badgeController),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Obx(() {
                  if (reviewController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (reviewController.errorMessage.value.isNotEmpty) {
                    return Text(reviewController.errorMessage.value);
                  }
                  if (reviewController.selectedSummary.value == null) {
                    return const Text('No reviews available');
                  }
                  return RatingBarWidget(
                    reviewPoints:
                        reviewController.selectedSummary.value!.reviewPoints,
                  );
                }),
              ),
              const SizedBox(height: 16),
              _buildTitleSection(item, controller),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDescriptionSection(item),
                    const SizedBox(height: 20),
                    _buildContactInfoSection(item),
                    const SizedBox(height: 30),
                    _buildCommentsButton(item),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTitleSection(Item item, ItemController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (item.tags ?? [])
                      .map((tag) => Text(
                            '#$tag',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          _buildUserEngagementWidget(controller),
        ],
      ),
    );
  }

  Widget _buildUserEngagementWidget(ItemController controller) {
    if (controller.engagementLoading.value) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (controller.engagementError.value.isNotEmpty) {
      return Tooltip(
        message: controller.engagementError.value,
        child: const Icon(Icons.error, color: Colors.red),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: EColor.paccent,
      ),
      child: Column(
        children: [
          Text("${controller.userEngagementPercentage.value}%"),
          const Text("User Avg"),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.description.isNotEmpty
              ? item.description
              : 'No description available',
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Email Address:', item.email),
        const SizedBox(height: 2),
        _buildInfoRow('Web Site:', item.website),
        const SizedBox(height: 2),
        _buildInfoRow('Contact No:', item.phoneNumber),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Text('$label ',
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Expanded(
          child: Text(
            (value == null || value.isEmpty) ? 'Not available' : value,
            style: const TextStyle(fontSize: 16, color: Colors.blue),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsButton(Item item) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        onPressed: () => Get.to(() =>
            CommentReviewScreen(itemId: item.id, categoryId: item.categoryId)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: const Text('View Comments'),
      ),
    );
  }

  Widget _buildImageSection(Item item, BadgeController badgeController) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // Main Item Image
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: _buildItemImage(item),
        ),

        // Badge Overlay
        Positioned(
          left: 16,
          bottom: 16,
          child: _buildBadgeSection(badgeController),
        ),
      ],
    );
  }

  Widget _buildItemImage(Item item) {
    if (item.profileImage.isEmpty) {
      return Center(
        child: Icon(Icons.storefront, size: 120, color: Colors.grey.shade400),
      );
    }

    return CachedNetworkImage(
      imageUrl: item.profileImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(EColor.primaryColor),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40, color: Colors.red.shade400),
            const SizedBox(height: 8),
            Text('Failed to load image',
                style: Get.textTheme.bodyMedium?.copyWith(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeSection(BadgeController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildBadgePlaceholder();
      }

      final badge = controller.badge.value;
      final badgeName = badge?.badgeName ?? 'Registered Shop';
      final imageUrl = badge?.badgeImageUrl ?? _defaultBadgeUrl;

      return Tooltip(
        message: badgeName,
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: // Add this to your existing code
              InkWell(
            onTap: () {
              if (badge != null) {
                Get.to(
                  () => BadgeDetailsScreen(
                    badgeName: badgeName,
                    badgeImageUrl: imageUrl,
                  ),
                  transition: Transition.cupertino,
                );
              } else {
                Get.snackbar(
                  'No Badge Information',
                  'This shop has not earned any special badges yet',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: EColor.primaryColor.withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBadgeImage(imageUrl),
                  const SizedBox(width: 8),
                  Text(
                    badgeName,
                    style: Get.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: EColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBadgeImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 40,
        height: 40,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade100,
          child: const Icon(Icons.verified, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildBadgePlaceholder() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  static const String _defaultBadgeUrl =
      'https://firebasestorage.googleapis.com/v0/b/echo-review-system.../default_badge.png';
}
