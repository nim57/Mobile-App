import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/constants/colors.dart';
import '../../common/widgets/appbar/appbar.dart';
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

    if (itemId == null) {
      return Scaffold(
        appBar: const EAppBar(titlt: Text('Item Details'), showBackArrow: true),
        body: const Center(child: Text('Item ID not provided')),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadItemForEdit(itemId);
      controller.loadUserEngagementData(itemId);
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
              _buildItemImage(item),
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
                    reviewPoints: reviewController.selectedSummary.value!.reviewPoints,
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

  Widget _buildItemImage(Item item) {
    final imageUrl = item.profileImage;
    return Center(
      child: (imageUrl.isNotEmpty)
          ? Image.network(
              imageUrl,
              height: 200,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Column(
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  Text('Failed to load image',
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Colors.red)),
                ],
              ),
            )
          : const Placeholder(fallbackHeight: 200),
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
}
