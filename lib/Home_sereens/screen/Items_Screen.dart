// items_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/appbar/appbar.dart'; // Update with your path
import '../item_backend/item_controller.dart';
import '../widgets/New_post/Item_tile2.dart';
import 'Item_Details.dart';

class Item_Screen extends StatelessWidget {
  const Item_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get passed category ID
    final String categoryId = Get.arguments as String;
    final ItemController controller = Get.put(ItemController());
    
    // Fetch items when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchItemsByCategory(categoryId);
    });

    return Scaffold(
      appBar: const EAppBar(
        titlt: Text('Items'),
        showBackArrow: true,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        // Handle loading state
        if (controller.itemLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle empty state
        if (controller.items.isEmpty) {
          return const Center(
            child: Text('No items found in this category'),
          );
        }

        // Handle error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                ElevatedButton(
                  onPressed: () => controller.fetchItemsByCategory(categoryId),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return Item_tile2(
                item: item,
                action: () => Get.to(() => const ItemDetailScreen(), arguments: item.id),
              );
            },
          ),
        );
      }),
    );
  }
}