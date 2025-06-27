import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../authentication_files/featuers/personalization/user_controller.dart';
import 'post_model.dart';
import 'post_repository.dart';

class PostController extends GetxController {
  static PostController get instance => Get.find();

  final PostRepository _repository = PostRepository();
  final UserController _userController = UserController.instonce;
  
  final TextEditingController descriptionController = TextEditingController();
  var isUploading = false.obs;

  Future<void> uploadTextPost({
    required String textContent,
    required Color backgroundColor,
    required TextStyle textStyle,
  }) async {
    try {
      isUploading.value = true;
      final user = _userController.user.value;
      
      final post = PostModel(
        userId: user.id,
        userName: user.fullname,
        userProfilePic: user.profilePicture,
        description: descriptionController.text.trim(),
        timestamp: DateTime.now(),
        type: PostType.text,
        textContent: textContent,
        backgroundColor: backgroundColor.value.toRadixString(16),
        textStyle: textStyle.toString(),
      );
      
      await _repository.uploadPost(post);
      _resetForm();
      Get.back();
      Get.snackbar('Success', 'Text post uploaded!');
    } catch (e) {
      Get.snackbar('Error', 'Text upload failed: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> uploadMediaPost(List<AssetEntity> mediaFiles) async {
    try {
      isUploading.value = true;
      final user = _userController.user.value;
      
      // Using public methods now
      final mediaUrls = await _repository.uploadMediaFiles(mediaFiles);
      final mediaTypes = _repository.getMediaTypes(mediaFiles);
      
      final post = PostModel(
        userId: user.id,
        userName: user.fullname,
        userProfilePic: user.profilePicture,
        description: descriptionController.text.trim(),
        timestamp: DateTime.now(),
        type: PostType.media,
        mediaUrls: mediaUrls,
        mediaTypes: mediaTypes,
      );
      
      await _repository.uploadPost(post);
      _resetForm();
      Get.back();
      Get.snackbar('Success', 'Media post uploaded!');
    } catch (e) {
      Get.snackbar('Error', 'Media upload failed: $e');
    } finally {
      isUploading.value = false;
    }
  }


    Future<void> deletePost(PostModel post) async {
    try {
      isUploading.value = true;
      await _repository.deletePost(post);
      Get.snackbar('Success', 'Post deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> updatePost(PostModel oldPost, PostModel newPost) async {
    try {
      isUploading.value = true;
      await _repository.updatePost(oldPost, newPost);
      Get.snackbar('Success', 'Post updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post: $e');
    } finally {
      isUploading.value = false;
    }
  }

  void _resetForm() {
    descriptionController.clear();
  }
}