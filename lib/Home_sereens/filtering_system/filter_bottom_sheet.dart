import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../badge_system/badge_repository.dart';
import '../item_backend/item_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  final String? initialCategory;
  final Set<String> initialBadges;
  final Function(String?, Set<String>) onApply;

  const FilterBottomSheet({super.key, 
    required this.initialCategory,
    required this.initialBadges,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final itemController = Get.find<ItemController>();
    final badgeOptions = BadgeRepository.badgeConditions.keys.toList();
    String? selectedCategory = initialCategory;
    Set<String> selectedBadges = Set.from(initialBadges);

    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter Reviews', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    onApply(selectedCategory, selectedBadges);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
            const Divider(),
            
            // Category Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Category', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            Obx(() => Wrap(
              spacing: 8,
              children: itemController.categoryIds.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    selectedCategory = selected ? category : null;
                  },
                );
              }).toList(),
            )),
            
            const Divider(),
            
            // Badges Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Seller Tier', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            Wrap(
              spacing: 8,
              children: badgeOptions.map((badge) {
                return FilterChip(
                  label: Text(badge),
                  selected: selectedBadges.contains(badge),
                  onSelected: (selected) {
                    selectedBadges.contains(badge)
                        ? selectedBadges.remove(badge)
                        : selectedBadges.add(badge);
                  },
                );
              }).toList(),
            ),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}