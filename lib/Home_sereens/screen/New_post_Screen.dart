// new_post_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../category_backend/category_controller.dart';
import '../widgets/New_post/item_tile.dart';
import 'Add_Mising_item.dart';
import 'Items_Screen.dart';
 // Update with your actual path

class NewPost_Screen extends StatelessWidget {
  const NewPost_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize category controller
    final controller = Get.put(CategoryController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // Show loading indicator while fetching categories
        if (controller.categoryLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // Show error message if no categories found
        if (controller.categories.isEmpty) {
          return const Center(
            child: Text('No categories found'),
          );
        }

        // Display categories in grid view
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Dynamic category grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    mainAxisExtent: 200,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (_, index) {
                    final category = controller.categories[index];
                    return Item_tile(
                      image: category.log, // Firebase image URL
                      name: category.name,
                      action: () => Get.to(
                        () => const Item_Screen(),
                        arguments: category.id, // Pass category ID to items screen
                      ),
                    );
                  },
                ),

                // Add missing item button
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70, right: 20),
                    child: GestureDetector(
                      onTap: () => Get.to(() => const Add_Mising_item()),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          color: Colors.blue,
                        ),
                        child: const Icon(Iconsax.add, 
                            size: 30, 
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}