// pending_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../category_backend/category_model.dart';
import 'pending_model.dart';
import 'pending_repository.dart';

class PendingController extends GetxController {

   final UserController _userController = Get.put(UserController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PendingRepository _repository = Get.put(PendingRepository());
  final RxList<Category> categories = <Category>[].obs;
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

  Future<void> uploadImage(XFile? file) async {
    if (file == null) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final bytes = await file.readAsBytes();
      final url = await _repository.uploadPendingImage(bytes);
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

  Future<void> submitPendingItem({
    required String categoryId,
    required String name,
    required List<String> tags,
    required String description,
    required String email,
    required String website,
    required String phone,
    required bool hasBranch,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final newItem = PendingItem(
        id: await _repository.generatePendingId(),
        categoryId: categoryId,
        name: name,
        tags: tags,
        description: description,
        email: email,
        website: website,
        phone: phone,
        mapLocation: mapLocation.value,
        imageUrl: imageUrl.value,
        hasBranch: hasBranch,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
         requesterUserId: _userController.user.value.id,
        requesterEmail: _userController.user.value.email,
      );

      await _repository.savePendingItem(newItem);
      Get.back();
      Get.snackbar('Success', 'Item submitted for approval');
    } catch (e) {
      errorMessage.value = 'Submission failed: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}