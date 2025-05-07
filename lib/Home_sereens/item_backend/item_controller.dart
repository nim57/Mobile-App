import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_project_123/Home_sereens/item_review_summry/item_review_summary_model.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../Utils/constants/image_Strings.dart';
import '../../../../../Utils/popups/fullscreen_loader.dart';
import '../../authentication_files/common/widgets/loaders/lodaders.dart';
import '../item_review_summry/item_review_repository.dart';
import 'item_model.dart';
import 'item_repository.dart';

class ItemController extends GetxController {
  static ItemController get instance => Get.find();

  // Repositories & Services
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final itemRepository = Get.put(ItemRepository());

  // Observables
  final itemLoading = false.obs;
  final RxList<Item> items = <Item>[].obs;
  final RxList<String> categoryIds = <String>[].obs;
  final selectedItem = Item.empty().obs;
  final imageUploading = false.obs;
  final hasBranch = false.obs;
  final errorMessage = ''.obs;
  final userEngagementPercentage = 0.0.obs;
  final engagementLoading = false.obs;
  final engagementError = ''.obs;

  // Form Controllers
  final categoryIdController = TextEditingController();
  final nameController = TextEditingController();
  final tagsController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final phoneController = TextEditingController();
  final mapLocationController = TextEditingController();

  // Workers
  late Worker _itemsWorker;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchAllItems();
    _setupWorkers();
  }

  void _setupWorkers() {
    _itemsWorker = ever(items, (_) => update());
  }

  /// Fetch all items with real-time updates
  Future<void> fetchAllItems() async {
    try {
      itemLoading.value = true;
      items.bindStream(itemRepository.getAllItemsStream());
    } catch (e) {
      items.assignAll([]);
      ELoaders.errorsnackBar(
          title: 'Load Failed', message: 'Failed to load items');
    } finally {
      itemLoading.value = false;
    }
  }

  /// Fetch available categories
  Future<void> fetchCategories() async {
    try {
      itemLoading.value = true;
      categoryIds.value = await itemRepository.getCategoryIds();
      if (categoryIds.isEmpty) {
        ELoaders.warningSnackBar(
            title: 'Warning', message: 'No categories found');
      }
    } catch (e) {
      categoryIds.assignAll([]);
      ELoaders.errorsnackBar(
          title: 'Error', message: 'Failed to load categories');
    } finally {
      itemLoading.value = false;
    }
  }

  /// Update map location
  void updateMapLocation(String locationUrl) {
    mapLocationController.text = locationUrl;
    update();
  }

  /// Clear map location
  void clearMapLocation() {
    mapLocationController.clear();
    update();
  }

  /// Create new item
  Future<void> createItem() async {
    try {
      EFullScreenLoader.openLoadingDialog('Creating Item...', EImages.E);

      if (categoryIdController.text.isEmpty) {
        throw 'Please select a category';
      }

      final newItem = Item(
        id: await itemRepository.generateItemId(),
        categoryId: categoryIdController.text.trim(),
        name: nameController.text.trim(),
        tags: tagsController.text.split(',').map((e) => e.trim()).toList(),
        description: descriptionController.text.trim(),
        email: emailController.text.trim(),
        website: websiteController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        mapLocation: mapLocationController.text.trim(),
        profileImage: selectedItem.value.profileImage,
        hasBranch: hasBranch.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await itemRepository.saveItem(newItem);
      items.add(newItem);

      clearForm();
      ELoaders.successSnackBor(
        title: 'Success!',
        message: 'Item created successfully',
      );
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: e.toString());
    } finally {
      EFullScreenLoader.stopLoading();
    }
  }

  /// Upload item image
  Future<void> uploadItemImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        imageUploading.value = true;

        final foundation.Uint8List imageBytes;
        final String fileName;

        if (foundation.kIsWeb) {
          imageBytes = await image.readAsBytes();
          fileName = DateTime.now().millisecondsSinceEpoch.toString();
        } else {
          final File imageFile = File(image.path);
          imageBytes = await imageFile.readAsBytes();
          fileName = image.name;
        }

        final imageUrl =
            await itemRepository.uploadItemImage(imageBytes, fileName);
        selectedItem.value =
            selectedItem.value.copyWith(profileImage: imageUrl);

        ELoaders.successSnackBor(
          title: 'Success!',
          message: 'Image uploaded successfully',
        );
      }
    } catch (e, stackTrace) {
      print('Upload Error: $e\n$stackTrace');
      ELoaders.errorsnackBar(
        title: 'Upload Error!',
        message: 'Failed to upload image: ${e.toString()}',
      );
    } finally {
      imageUploading.value = false;
    }
  }

  // Add this to your ItemController
  Future<void> loadItemForEdit(String itemId) async {
    try {
      itemLoading.value = true;
      final item = await itemRepository.getItemById(itemId);
      selectedItem.value = item;
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: 'Failed to load item');
    } finally {
      itemLoading.value = false;
    }
  }

  /// Update existing item
  Future<void> updateItem() async {
    try {
      EFullScreenLoader.openLoadingDialog('Updating Item...', EImages.E);

      final updateData = <String, dynamic>{
        'categoryId': categoryIdController.text.trim(),
        'name': nameController.text.trim(),
        'tags': tagsController.text.split(',').map((e) => e.trim()).toList(),
        'description': descriptionController.text.trim(),
        'email': emailController.text.trim(),
        'website': websiteController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'mapLocation': mapLocationController.text.trim(),
        'hasBranch': hasBranch.value,
        'updatedAt': DateTime.now(),
      };

      if (selectedItem.value.profileImage !=
          items.firstWhere((i) => i.id == selectedItem.value.id).profileImage) {
        updateData['profileImage'] = selectedItem.value.profileImage;
      }

      await itemRepository.updateItemFields(
        itemId: selectedItem.value.id,
        fields: updateData,
      );

      final index = items.indexWhere((i) => i.id == selectedItem.value.id);
      if (index != -1) {
        items[index] = items[index].copyWith(
          categoryId: updateData['categoryId'],
          name: updateData['name'],
          tags: updateData['tags'] as List<String>,
          description: updateData['description'],
          email: updateData['email'],
          website: updateData['website'],
          phoneNumber: updateData['phoneNumber'],
          mapLocation: updateData['mapLocation'],
          profileImage: updateData['profileImage'] ?? items[index].profileImage,
          hasBranch: updateData['hasBranch'],
          updatedAt: updateData['updatedAt'],
        );
      }

      ELoaders.successSnackBor(
        title: 'Success!',
        message: 'Item updated successfully',
      );
      Get.back();
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: e.toString());
    } finally {
      EFullScreenLoader.stopLoading();
    }
  }

  Future<void> fetchItemsByCategory(String categoryId) async {
    try {
      itemLoading.value = true;
      errorMessage.value = '';
      items.bindStream(
        itemRepository.streamItemsByCategory(categoryId),
      );
    } on FirebaseException catch (e) {
      errorMessage.value = 'Firebase Error: ${e.message}';
      items.assignAll([]);
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      items.assignAll([]);
    } finally {
      itemLoading.value = false;
    }
  }

  /// Delete item
  Future<void> deleteItem(String itemId) async {
    try {
      EFullScreenLoader.openLoadingDialog('Deleting...', EImages.E);
      await itemRepository.deleteItem(itemId);
      items.removeWhere((i) => i.id == itemId);
      ELoaders.successSnackBor(
        title: 'Success!',
        message: 'Item deleted successfully',
      );
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: e.toString());
    } finally {
      EFullScreenLoader.stopLoading();
      Get.back();
    }
  }

  void clearItems() {
    items.assignAll([]);
    errorMessage.value = '';
  }

  /// Clear form fields
  void clearForm() {
    categoryIdController.clear();
    nameController.clear();
    tagsController.clear();
    descriptionController.clear();
    emailController.clear();
    websiteController.clear();
    phoneController.clear();
    mapLocationController.clear();
    hasBranch.value = false;
    selectedItem.value = Item.empty();
  }

  /// Populate form fields for editing
  void _populateFormFields(Item item) {
    categoryIdController.text = item.categoryId;
    nameController.text = item.name;
    tagsController.text = item.tags.join(', ');
    descriptionController.text = item.description;
    emailController.text = item.email;
    websiteController.text = item.website;
    phoneController.text = item.phoneNumber;
    mapLocationController.text = item.mapLocation;
    hasBranch.value = item.hasBranch;
  }

  @override
  void onClose() {
    _itemsWorker.dispose();
    super.onClose();
    categoryIdController.dispose();
    nameController.dispose();
    tagsController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    websiteController.dispose();
    phoneController.dispose();
    mapLocationController.dispose();
  }

  /// user presentage calculation

  Future<void> loadUserEngagementData(String itemId) async {
    try {
      engagementLoading.value = true;
      engagementError.value = '';

      // Get total unique users
      final totalUsers = await _getTotalUniqueUsers();
      print('Total unique users: $totalUsers');

      // Get users who reviewed/commented on this item
      final engagedUsers = await _getEngagedUsers(itemId);
      print('Engaged users for item $itemId: ${engagedUsers.length}');

      // Calculate percentage
      if (totalUsers > 0) {
        userEngagementPercentage.value =
            ((engagedUsers.length / totalUsers) * 100).roundToDouble();
      } else {
        userEngagementPercentage.value = 0.0;
        engagementError.value = 'No users available';
      }
    } catch (e) {
      engagementError.value = 'Failed to load engagement data: ${e.toString()}';
      userEngagementPercentage.value = 0.0;
      print('Error in loadUserEngagementData: $e');
    } finally {
      engagementLoading.value = false;
    }
  }

  Future<int> _getTotalUniqueUsers() async {
    try {
      final query = await _firestore
          .collection('users')
          .get(const GetOptions(source: Source.server));

      return query.size;
    } catch (e) {
      throw 'Failed to get total users: ${e.toString()}';
    }
  }

  Future<List<String>> _getEngagedUsers(String itemId) async {
    try {
      // Assuming reviews are stored in a 'reviews' collection
      // with both 'userId' and 'itemId' fields
      final reviewsQuery = await _firestore
          .collection('reviews')
          .where('itemId', isEqualTo: itemId)
          .get(const GetOptions(source: Source.server));

      // Get unique user IDs from reviews
      final userIds = reviewsQuery.docs
          .map((doc) => doc.data()['userId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      return userIds;
    } catch (e) {
      throw 'Failed to get engaged users: ${e.toString()}';
    }
  }

  Future<ItemReviewSummary?> getReviewSummary(String itemId) async {
    try {
      return await ItemReviewRepository.instance.getSummaryByItem(itemId);
    } catch (e) {
      print('Error getting review summary: $e');
      return null;
    }
  }
}
