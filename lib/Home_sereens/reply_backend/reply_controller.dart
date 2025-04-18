// reply_controller.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'reply_model.dart';
import 'reply_repository.dart';

class ReplyController extends GetxController {
  final ReplyRepository _replyRepository = ReplyRepository();
  final RxList<XFile> selectedMedia = <XFile>[].obs;
  final RxBool isVisible = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool showEmojiPicker = false.obs;
  final RxMap<String, bool> expandedReplies = <String, bool>{}.obs;
  final RxMap<String, int> likedReplies = <String, int>{}.obs;
  final RxMap<String, int> dislikedReplies = <String, int>{}.obs;
  final RxMap<String, bool> userLikes = <String, bool>{}.obs;
  final RxMap<String, bool> userDislikes = <String, bool>{}.obs;
   final RxString editingReplyId = ''.obs;
  final RxList<String> existingMediaUrls = <String>[].obs;

  // Initialize likes and dislikes for replies
  void initializeLikesDislikes(List<ReplyModel> replies) {
    for (var reply in replies) {
      likedReplies[reply.replyId] = reply.likes;
      dislikedReplies[reply.replyId] = reply.dislikes;
      userLikes[reply.replyId] = false;
      userDislikes[reply.replyId] = false;
    }
  }

  String getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) return '${(difference.inDays ~/ 365)}y ago';
    if (difference.inDays > 30) return '${(difference.inDays ~/ 30)}mo ago';
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  void toggleExpansion(String parentId) {
    expandedReplies[parentId] = !(expandedReplies[parentId] ?? false);
  }

  Future<void> toggleLike(String replyId) async {
    try {
      final current = userLikes[replyId] ?? false;
      userLikes[replyId] = !current;
      likedReplies[replyId] = (likedReplies[replyId] ?? 0) + (current ? -1 : 1);
      
      await _replyRepository.updateLikes(replyId, likedReplies[replyId]!);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update like: ${e.toString()}');
    }
  }

  Future<void> toggleDislike(String replyId) async {
    try {
      final current = userDislikes[replyId] ?? false;
      userDislikes[replyId] = !current;
      dislikedReplies[replyId] = (dislikedReplies[replyId] ?? 0) + (current ? -1 : 1);
      
      await _replyRepository.updateDislikes(replyId, dislikedReplies[replyId]!);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update dislike: ${e.toString()}');
    }
  }

  void toggleEmojiPicker() => showEmojiPicker.toggle();

  Future<void> pickMultipleMedia() async {
    try {
      final List<XFile> files = await ImagePicker().pickMultipleMedia(
        requestFullMetadata: false,
      );
      selectedMedia.addAll(files);
        } on PlatformException catch (e) {
      Get.snackbar('Error', 'Failed to pick media: ${e.message}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick media: ${e.toString()}');
    }
  }

  void removeMedia(int index) {
    if (index >= 0 && index < selectedMedia.length) {
      selectedMedia.removeAt(index);
    }
  }

  void toggleVisibility(bool value) => isVisible.value = value;

  Future<void> submitReply({
    required String text,
    required String parentId,
    required String itemId,
    required String authorId,
    required String authorName,
    required String authorEmail,
    required String prefecture,
  }) async {
    try {
      isLoading(true);

      // 1. Upload media files first
    final List<String> mediaUrls = [];
    for (final media in selectedMedia) {
      final url = await _replyRepository.uploadMedia(media);
      mediaUrls.add(url);
    }

      
      final reply = ReplyModel(
        replyId: const Uuid().v4(),
        parentId: parentId,
        itemId: itemId,
        authorId: authorId,
        authorName: authorName,
        authorEmail: authorEmail,
        prefecture: prefecture,
        text: text,
        mediaUrls: mediaUrls,
        emojis: _extractEmojis(text),
        timestamp: DateTime.now(),
        isVisible: isVisible.value,
        likes: 0,
        dislikes: 0,
      );

      await _replyRepository.addReply(reply);
      
      selectedMedia.clear();
      isVisible.value = true;
      showEmojiPicker.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  List<String> _extractEmojis(String text) {
    final emojiRegex = RegExp(
      r'(\p{Emoji_Presentation}|\p{Emoji}\uFE0F)',
      unicode: true,
    );
    return emojiRegex.allMatches(text).map((m) => m.group(0)!).toList();
  }

  void startEditing(ReplyModel reply) {
    editingReplyId.value = reply.replyId;
    existingMediaUrls.value = List.from(reply.mediaUrls);
  }

  Future<void> deleteReply(String replyId) async {
    try {
      await _replyRepository.deleteReply(replyId);
      Get.back(); // Close dialog
      Get.snackbar('Success', 'Reply deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete reply: ${e.toString()}');
    }
  }

  Future<void> updateReply({
    required String replyId,
    required String text,
  }) async {
    try {
      isLoading(true);

      // Upload new media
      final List<String> newMediaUrls = [];
      for (final media in selectedMedia) {
        final url = await _replyRepository.uploadMedia(media);
        newMediaUrls.add(url);
      }

      // Combine existing media with new media
      final allMediaUrls = [...existingMediaUrls, ...newMediaUrls];

      await _replyRepository.updateReply(
        replyId: replyId,
        text: text,
        mediaUrls: allMediaUrls,
        isVisible: isVisible.value,
      );

      // Reset state
      selectedMedia.clear();
      existingMediaUrls.clear();
      editingReplyId.value = '';
      isVisible.value = true;
      showEmojiPicker.value = false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
