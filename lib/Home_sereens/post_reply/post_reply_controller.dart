import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'post_reply_model.dart';
import 'post_reply_repository.dart';

class PostReplyController extends GetxController {
  final PostReplyRepository _repository = PostReplyRepository();
  final RxList<PostReplyModel> replies = <PostReplyModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Fetch replies for a comment
  void fetchReplies(String commentId) {
    isLoading.value = true;
    _repository.getRepliesForComment(commentId).listen((repliesList) {
      replies.assignAll(repliesList);
      isLoading.value = false;
      error.value = '';
    }, onError: (e) {
      error.value = 'Failed to load replies: $e';
      isLoading.value = false;
    });
  }

  Future<void> addReply({
    required String commentId,
    required String content,
    List<AssetEntity>? mediaFiles,
    required bool profileVisibility,
  }) async {
    try {
      isLoading.value = true;
      
      List<String>? mediaUrls;
      List<String>? mediaTypes;
      
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        // Implement media upload logic
      }
      
      // Create reply object
      final reply = PostReplyModel(
        id: '',
        commentId: commentId,
        userId: 'current_user_id', // Replace with actual user ID
        userName: 'Current User', // Replace with actual user name
        userProfilePic: 'profile_url', // Replace with actual profile URL
        content: content,
        mediaUrls: mediaUrls,
        mediaTypes: mediaTypes,
        profileVisibility: profileVisibility,
        timestamp: Timestamp.now(),
      );
      
      await _repository.addReply(reply);
      error.value = '';
    } catch (e) {
      error.value = 'Failed to add reply: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateReply(PostReplyModel reply, String newContent) async {
    try {
      isLoading.value = true;
      final updatedReply = PostReplyModel(
        id: reply.id,
        commentId: reply.commentId,
        userId: reply.userId,
        userName: reply.userName,
        userProfilePic: reply.userProfilePic,
        content: newContent,
        mediaUrls: reply.mediaUrls,
        mediaTypes: reply.mediaTypes,
        profileVisibility: reply.profileVisibility,
        timestamp: reply.timestamp,
      );
      
      await _repository.updateReply(updatedReply);
      error.value = '';
    } catch (e) {
      error.value = 'Failed to update reply: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteReply(String replyId) async {
    try {
      isLoading.value = true;
      await _repository.deleteReply(replyId);
      error.value = '';
    } catch (e) {
      error.value = 'Failed to delete reply: $e';
    } finally {
      isLoading.value = false;
    }
  }
}