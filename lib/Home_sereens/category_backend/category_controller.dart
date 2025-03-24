import 'dart:io';

import 'package:echo_project_123/Home_sereens/category_backend/category_model.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../Utils/constants/image_Strings.dart';
import '../../../../../Utils/popups/fullscreen_loader.dart';
import '../../authentication_files/common/widgets/loaders/lodaders.dart';
import 'category_repostory.dart';


class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final categoryLoading = false.obs;
  final RxList<Category> categories = <Category>[].obs;
  final selectedCategory = Category.empty().obs;
  final imageUploading = false.obs;
  final categoryRepository = Get.put(CategoryRepository());
  final nameController = TextEditingController();
  final logController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllCategories();
  }

  /// Fetch all categories
  // In CategoryController
  Future<void> fetchAllCategories() async {
    try {
      categoryLoading.value = true;
      final fetchedCategories = await categoryRepository.getAllCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      categories.assignAll([]);
      ELoaders.errorsnackBar(
          title: 'Load Failed', message: 'Failed to load categories');
    } finally {
      categoryLoading.value = false;
    }
  }

  /// Generate new category ID starting with 0001
  Future<String> _generateNewCategoryId() async {
    final counterDoc = await categoryRepository.db
        .collection('counters')
        .doc('categoryId')
        .get();

    int currentCount = counterDoc.exists ? counterDoc.data()!['count'] : 0;
    currentCount++;
    final newId = currentCount.toString().padLeft(4, '0');

    await categoryRepository.db
        .collection('counters')
        .doc('categoryId')
        .set({'count': currentCount});

    return newId;
  }

  /// Initialize category ID counter
  Future<void> _initializeCategoryIdCounter() async {
    await categoryRepository.db
        .collection('counters')
        .doc('categoryId')
        .set({'count': 0});
  }

  /// Create new category
  Future<void> createCategory() async {
    try {
      EFullScreenLoader.openLoadingDialog('Creating Category...', EImages.E);

      // Generate new ID
      final newId = await _generateNewCategoryId();

      // Create new category
      final newCategory = Category(
        id: newId,
        name: nameController.text.trim(),
        log: selectedCategory.value.log,
      );

      // Save to Firestore
      await categoryRepository.saveCategory(newCategory);

      // Add to local list
      categories.add(newCategory);

      // Clear form
      nameController.clear();
      selectedCategory.value = Category.empty();

      ELoaders.successSnackBor(
        title: 'Success!',
        message: 'Category created successfully',
      );
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: e.toString());
    } finally {
      EFullScreenLoader.stopLoading();
    }
  }

  /// Upload category image
  Future<void> uploadCategoryImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        imageUploading.value = true;

        // Platform-aware file handling
        final Uint8List imageBytes;
        final String fileName;

        if (foundation.kIsWeb) {
          // Web-specific handling
          imageBytes = await image.readAsBytes();
          fileName = DateTime.now().millisecondsSinceEpoch.toString();
        } else {
          // Mobile/Desktop handling
          final File imageFile = File(image.path);
          imageBytes = await imageFile.readAsBytes();
          fileName = image.name;
        }

        // Upload using bytes
        final imageUrl = await categoryRepository.uploadCategoryImage(
          imageBytes,
          fileName: fileName,
        );

        selectedCategory.value = selectedCategory.value.copyWith(
          log: imageUrl,
        );

        ELoaders.successSnackBor(
          title: 'Success!',
          message: 'Image uploaded successfully',
        );
      }
    } catch (e, stackTrace) {
      print('Upload Error: $e');
      print('Stack Trace: $stackTrace');
      ELoaders.errorsnackBar(
        title: 'Upload Error!',
        message: 'Failed to upload image: ${e.toString()}',
      );
    } finally {
      imageUploading.value = false;
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      EFullScreenLoader.openLoadingDialog('Deleting...', EImages.E);
      await categoryRepository.deleteCategory(categoryId);
      categories.removeWhere((c) => c.id == categoryId);
      ELoaders.successSnackBor(
        title: 'Success!',
        message: 'Category deleted successfully',
      );
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: e.toString());
    } finally {
      EFullScreenLoader.stopLoading();
      Get.back();
    }
  }

   Future<void> loadCategoryForEdit(String categoryId) async {
    try {
      categoryLoading.value = true;
      final category = await categoryRepository.getCategoryById(categoryId);
      selectedCategory.value = category;
      nameController.text = category.name;
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: 'Failed to load category');
    } finally {
      categoryLoading.value = false;
    }
  }

  Future<void> updateCategory() async {
    try {
      categoryLoading.value = true;
      final updateData = <String, dynamic>{
        'name': nameController.text.trim(),
        if (selectedCategory.value.log != 
            categories.firstWhere((c) => c.id == selectedCategory.value.id).log)
          'log': selectedCategory.value.log,
        'updatedAt': DateTime.now().toString(),
      };

      await categoryRepository.updateCategoryFields(
        categoryId: selectedCategory.value.id,
        fields: updateData,
      );

      // Update local list
      final index = categories.indexWhere((c) => c.id == selectedCategory.value.id);
      if (index != -1) {
        categories[index] = categories[index].copyWith(
          name: updateData['name'],
          log: updateData['log'] ?? categories[index].log,
        );
      }

      ELoaders.successSnackBor(
        title: 'Success!',
        message: 'Category updated successfully',
      );
      Get.back();
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Error!', message: e.toString());
    } finally {
      categoryLoading.value = false;
    }
  }


  
}
