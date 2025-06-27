import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'post_comment_model.dart';
import 'post_comment_repository.dart';

class PostCommentController extends GetxController {
  final PostCommentRepository _repository = PostCommentRepository();
  final RxList<PostCommentModel> comments = <PostCommentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Add a new comment
  Future<void> addComment({
    required String postId,
    required String content,
    List<AssetEntity>? mediaFiles,
    required bool profileVisibility,
  }) async {
    try {
      isLoading.value = true;
      
      List<String>? mediaUrls;
      List<String>? mediaTypes;
      
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        mediaUrls = await _repository.uploadMediaFiles(mediaFiles);
        mediaTypes = _repository.getMediaTypes(mediaFiles);
      }
      
      final comment = PostCommentModel(
        id: '',
        postId: postId,
        userId: 'current_user_id', // Replace with actual user ID
        userName: 'Current User', // Replace with actual user name
        userProfilePic: 'profile_url', // Replace with actual profile URL
        content: content,
        mediaUrls: mediaUrls,
        mediaTypes: mediaTypes,
        profileVisibility: profileVisibility,
        timestamp: Timestamp.now(),
      );
      
      await _repository.addComment(comment);
      error.value = '';
    } catch (e) {
      error.value = 'Failed to add comment: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Update a comment
  Future<void> updateComment(PostCommentModel comment, String newContent) async {
    try {
      isLoading.value = true;
      final updatedComment = PostCommentModel(
        id: comment.id,
        postId: comment.postId,
        userId: comment.userId,
        userName: comment.userName,
        userProfilePic: comment.userProfilePic,
        content: newContent,
        mediaUrls: comment.mediaUrls,
        mediaTypes: comment.mediaTypes,
        profileVisibility: comment.profileVisibility,
        timestamp: comment.timestamp,
      );
      
      await _repository.updateComment(updatedComment);
      error.value = '';
    } catch (e) {
      error.value = 'Failed to update comment: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a comment
  Future<void> deleteComment(String commentId) async {
    try {
      isLoading.value = true;
      await _repository.deleteComment(commentId);
      error.value = '';
    } catch (e) {
      error.value = 'Failed to delete comment: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Load comments for a post
  void loadCommentsForPost(String postId) {
    _repository.getCommentsForPost(postId).listen((commentsList) {
      comments.assignAll(commentsList);
      error.value = '';
    }, onError: (e) {
      error.value = 'Failed to load comments: $e';
    });
  }
}