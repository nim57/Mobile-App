// comment_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'comment_model.dart';
import 'comment_repotory.dart';

class CommentController extends GetxController {
  static CommentController get instance => Get.find();

  final CommentRepository _repository = CommentRepository();
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isVisible = true.obs;
  final RxString errorMessage = ''.obs;
  StreamSubscription<List<CommentModel>>? _commentsSubscription;

  Future<void> submitComment({
    required String itemId,
    required List<String> tags,
    required String title,
    required String text,
    required String userId,
    required String username,
    required String userProfile,
  }) async {
    try {
      final comment = CommentModel(
        commentId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        itemId: itemId,
        text: text,
        isVisible: isVisible.value,
        username: username,
        userProfile: userProfile,
        tags: tags,
        title: title,
        timestamp: Timestamp.now(),
      );

      await _repository.addComment(comment);
      Get.snackbar('Success', 'Comment submitted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchComments(String itemId) {
    isLoading(true);
    errorMessage('');
    _commentsSubscription?.cancel();

    _commentsSubscription = _repository.getCommentsStream(itemId).listen(
      (commentsList) {
        comments.value = commentsList;
        isLoading(false);
      },
      onError: (e) {
        if (e.toString().contains('index')) {
          _showIndexErrorDialog(e.toString());
        } else {
          errorMessage.value = e.toString();
        }
        isLoading(false);
      },
    );
  }

  void _showIndexErrorDialog(String error) {
    Get.dialog(
      AlertDialog(
        title: const Text('Index Required'),
        content: Column(
          children: [
            const Text('The app needs a database index to load comments.'),
            const SizedBox(height: 10),
            SelectableText(
              error.split('link: ')[1],
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Continue'),
            onPressed: () {
              Get.back();
              // Optional: Retry after delay
              Future.delayed(
                  const Duration(minutes: 3), () => fetchComments(error));
            },
          ),
        ],
      ),
      barrierDismissible: true, // Allows tapping outside
    );
  }

  String getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays > 365) return '${(difference.inDays ~/ 365)}y ago';
    if (difference.inDays > 30) return '${(difference.inDays ~/ 30)}mo ago';
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  @override
  void onClose() {
    _commentsSubscription?.cancel();
    super.onClose();
  }
}
