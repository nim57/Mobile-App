// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:photo_manager/photo_manager.dart';

// import '../../authentication_files/featuers/personalization/user_controller.dart';
// import 'media_post_model.dart';
// import 'media_post_repository.dart';

// class MediaPostController extends GetxController {
//   static MediaPostController get instance => Get.find();

//   final MediaPostRepository _mediaPostRepository = MediaPostRepository();
//   final UserController _userController = UserController.instonce;
  
//   final TextEditingController descriptionController = TextEditingController();
//   var isUploading = false.obs;

//   // Upload media post
//   Future<void> uploadMediaPost(List<AssetEntity> mediaFiles) async {
//     try {
//       isUploading.value = true;
      
//       // Get user data
//       final user = _userController.user.value;
      
//       // Upload media files to storage
//       final mediaUrls = await _mediaPostRepository.uploadMediaFiles(mediaFiles);
//       final mediaTypes = _mediaPostRepository.getMediaTypes(mediaFiles);
      
//       // Create post model
//       final post = MediaPostModel(
//         userId: user.id,
//         userName: user.fullname,
//         userProfilePic: user.profilePicture,
//         description: descriptionController.text.trim(),
//         mediaUrls: mediaUrls,
//         mediaTypes: mediaTypes,
//         timestamp: DateTime.now(),
//       );
      
//       // Upload to Firebase
//       await _mediaPostRepository.uploadMediaPost(post);
      
//       // Reset form
//       descriptionController.clear();
      
//       isUploading.value = false;
//       Get.back(); // Close post screen
//       Get.snackbar('Success', 'Post uploaded successfully!');
//     } catch (e) {
//       isUploading.value = false;
//       Get.snackbar('Error', 'Failed to upload post: $e');
//     }
//   }
// }