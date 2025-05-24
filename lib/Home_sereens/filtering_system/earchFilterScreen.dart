import 'package:echo_project_123/Home_sereens/filtering_system/ReviewItemCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../item_backend/item_controller.dart';
import '../item_backend/item_model.dart';
import 'filter_bottom_sheet.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ItemController itemController = Get.put(ItemController());
  final List<String> selectedFilters = [];
  final List<String> selectedHashtags = [];
  String searchQuery = '';
  String? selectedCategory;
Set<String> selectedBadges = {};

  @override
  void initState() {
    super.initState();
    itemController.fetchAllItems();
  }

  void _showFilterBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => FilterBottomSheet(
      initialCategory: selectedCategory,
      initialBadges: selectedBadges,
      onApply: (category, badges) async {
        setState(() {
          selectedCategory = category;
          selectedBadges = badges;
        });
      },
    ),
  );
}

// Update filteredItems method
List<Item> filteredItems(List<Item> allItems) {
  return allItems.where((item) {
    // Search filter
    final matchesSearch = searchQuery.isEmpty ||
        item.name.toLowerCase().contains(searchQuery) ||
        item.description.toLowerCase().contains(searchQuery) ||
        item.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
    
    // Category filter
    final matchesCategory = selectedCategory == null || 
        item.categoryId == selectedCategory;
    
    return matchesSearch && matchesCategory;
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Search & Filter'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.search_normal),
                      hintText: 'Search reviews...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      searchQuery = value.toLowerCase();
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Iconsax.filter, size: 30),
                  onPressed: () =>  _showFilterBottomSheet(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (itemController.itemLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = filteredItems(itemController.items);

              if (items.isEmpty) {
                return const Center(child: Text('No items found'));
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => ReviewItemCard(
                  item: items[index],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
