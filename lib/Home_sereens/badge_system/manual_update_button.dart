// manual_update_button.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../item_backend/item_controller.dart';

class ManualUpdateButton extends StatelessWidget {
  const ManualUpdateButton({super.key}); // Remove itemId

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemController());
    return Obx(() => ElevatedButton(
          onPressed: controller.allItemsLoading.value
              ? null
              : () async {
                  try {
                    await controller.updateAllItemsReviewSummary();
                    Get.snackbar(
                        'Success', 'All items review metrics updated!');
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
          child: controller.allItemsLoading.value
              ? const CircularProgressIndicator()
              : const Text('Update All Review Metrics'), // Update button text
        ));
  }
}
