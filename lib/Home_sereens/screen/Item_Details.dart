import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/constants/colors.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../item_backend/item_controller.dart';
import '../item_backend/item_model.dart';
import '../widgets/widgets_home/ratingBarWidget.dart';
import 'Comment&ReviewScreen.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.put(ItemController());
    final String itemId = Get.arguments as String;

    // Fetch item details when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadItemForEdit(itemId);
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

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Image
              _buildItemImage(item),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    _buildTitleSection(item),
                    const SizedBox(height: 25),

                    // Static Rating Section (as per requirements)
                    const RatingBarWidget(
                      customerServiceRating: 57,
                      qualityOfServiceRating: 37,
                    ),
                    const SizedBox(height: 25),

                    // Description
                    _buildDescriptionSection(item),
                    const SizedBox(height: 16),

                    // Contact Information
                    _buildContactInfoSection(item),
                    const SizedBox(height: 32),

                    // View Comments Button
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
    return Center(
      child: item.profileImage.isNotEmpty
          ? Image.network(
              item.profileImage,
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

  Widget _buildTitleSection(Item item) {
    return Row(
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
              // Tags
              Wrap(
                spacing: 8,
                children: item.tags
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
        // Static Percentage Box (as per requirements)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: EColor.paccent,
          ),
          child: const Column(
            children: [
              Text("48%"),
              Text("User Avg"),
            ],
          ),
        ),
      ],
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label ',
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : 'Not available',
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
        onPressed: () => Get.to(() => CommentReviewScreen(
          itemId: item.id, 
          categoryId: item.categoryId
          
        )),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: const Text('View Comments'),
      ),
    );
  }
}