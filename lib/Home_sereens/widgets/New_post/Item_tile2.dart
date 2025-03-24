// item_tile2.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../item_backend/item_model.dart';
 // Update with your path

class Item_tile2 extends StatelessWidget {
  const Item_tile2({
    super.key,
    required this.item,
    this.action,
  });

  final Item item;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Item Image from Firebase
            _buildItemImage(),
            const SizedBox(height: 8),
            // Item Name
            Text(
              item.name,
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    return item.profileImage.isNotEmpty
        ? Image.network(
            item.profileImage,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 120,
                height: 120,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 40, color: Colors.red),
                Text(
                  'Failed to load image',
                  style: Get.textTheme.bodySmall?.copyWith(color: Colors.red),
                )
              ],
            ),
          )
        : const Placeholder(
            fallbackHeight: 120,
            fallbackWidth: 120,
          );
  }
}