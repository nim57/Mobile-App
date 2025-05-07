import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../category_backend/category_model.dart';
import 'branch_model.dart';
import 'branch_repository.dart';

class BranchController extends GetxController {
  final UserController _userController = Get.put(UserController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BranchRepository _repository = Get.put(BranchRepository());
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Map<String, dynamic>> mainItems = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString imageUrl = ''.obs;
  final RxString mapLocation = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final QuerySnapshot snapshot = 
          await _firestore.collection('categories').get();
      categories.assignAll(
        snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList()
      );
    } catch (e) {
      errorMessage.value = 'Failed to load categories: ${e.toString()}';
      categories.clear();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMainItems(String categoryId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final QuerySnapshot snapshot = await _firestore.collection('items')
        .where('categoryId', isEqualTo: categoryId)
        .where('hasBranch', isEqualTo: true)
        .get();
      
      mainItems.assignAll(
        snapshot.docs.map((doc) => {
          'id': doc.id,
          'name': doc['name'],
          ...doc.data() as Map<String, dynamic>
        }).toList()
      );
    } catch (e) {
      errorMessage.value = 'Failed to load main items: ${e.toString()}';
      mainItems.clear();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadImage(XFile? file) async {
    if (file == null) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final bytes = await file.readAsBytes();
      final url = await _repository.uploadBranchImage(bytes);
      imageUrl.value = url;
    } catch (e) {
      errorMessage.value = 'Image upload failed: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void clearImage() => imageUrl.value = '';

  void updateMapLocation(String location) => mapLocation.value = location;

  Future<void> submitBranch({
    required String categoryId,
    required String mainItemId,
    required String name,
    required List<String> tags,
    required String description,
    required String email,
    required String website,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final newBranch = BranchPending(
        id: await _repository.generateBranchId(),
        categoryId: categoryId,
        mainItemId: mainItemId,
        name: name,
        tags: tags,
        description: description,
        email: email,
        website: website,
        phone: phone,
        mapLocation: mapLocation.value,
        imageUrl: imageUrl.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        requesterUserId: _userController.user.value.id,
        requesterEmail: _userController.user.value.email,
      );

      await _repository.saveBranchPending(newBranch);
      Get.back();
      Get.snackbar('Success', 'Branch submitted for approval');
    } catch (e) {
      errorMessage.value = 'Submission failed: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}