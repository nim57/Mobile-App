import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../Utils/constants/sizes.dart';
import '../../../Utils/helpers/helper_function.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../post_comment/post_comment_model.dart';
import 'add_reply_screen.dart';
import 'post_reply_controller.dart';
import 'post_reply_model.dart';

class RepliesScreen extends StatelessWidget {
  final PostCommentModel comment;
  
  const RepliesScreen({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final replyController = Get.put(PostReplyController());
    replyController.fetchReplies(comment.id);
    final userController = Get.find<UserController>();
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Replies')),
      body: Column(
        children: [
          // Original Comment
          Card(
            margin: const EdgeInsets.all(ESizes.defaultSpace),
            child: Padding(
              padding: const EdgeInsets.all(ESizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(comment.userProfilePic),
                        radius: 20,
                      ),
                      const SizedBox(width: ESizes.spaceBtwItems),
                      Text(comment.userName, 
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: ESizes.spaceBtwItems),
                  Text(comment.content),
                ],
              ),
            ),
          ),
          const Divider(),

          // Replies List
          Expanded(
            child: Obx(() {
              if (replyController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (replyController.error.value.isNotEmpty) {
                return Center(child: Text(replyController.error.value));
              }

              if (replyController.replies.isEmpty) {
                return const Center(child: Text('No replies yet'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(ESizes.defaultSpace),
                itemCount: replyController.replies.length,
                itemBuilder: (context, index) {
                  final reply = replyController.replies[index];
                  return ReplyCard(reply: reply, comment: comment);
                },
              );
            }),
          ),
          _buildAddReplyButton(context),
        ],
      ),
    );
  }

  Widget _buildAddReplyButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () => Get.to(() => AddReplyScreen(comment: comment)),
              icon: const Icon(Icons.reply),
              label: const Text('Add a reply'),
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final PostReplyModel reply;
  final PostCommentModel comment;

  const ReplyCard({super.key, required this.reply, required this.comment});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final isCurrentUser = userController.user.value.id == reply.userId;

    return Card(
      margin: const EdgeInsets.only(bottom: ESizes.spaceBtwItems),
      child: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reply Header
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(reply.userProfilePic),
                  radius: 20,
                ),
                const SizedBox(width: ESizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reply.userName, 
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        timeago.format(reply.timestamp.toDate()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) => _handleMenuSelection(value, reply, context),
                  itemBuilder: (context) {
                    if (isCurrentUser) {
                      return [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ];
                    } else {
                      return [
                        const PopupMenuItem(value: 'report', child: Text('Report')),
                      ];
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: ESizes.spaceBtwItems),

            // Reply Content
            Text(reply.content),
            const SizedBox(height: ESizes.spaceBtwItems),

            // Reply Media
            if (reply.mediaUrls != null && reply.mediaUrls!.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: reply.mediaUrls!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: ESizes.spaceBtwItems),
                      child: Image.network(
                        reply.mediaUrls![index], 
                        width: 150, 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 150,
                            color: Colors.grey,
                            child: const Center(child: Icon(Icons.error)),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: ESizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(String value, PostReplyModel reply, BuildContext context) {
    final replyController = Get.find<PostReplyController>();
    switch (value) {
      case 'edit':
        Get.to(() => AddReplyScreen(
          comment: comment, 
          reply: reply,
          isEditing: true,
        ));
        break;
      case 'delete':
        Get.dialog(
          AlertDialog(
            title: const Text('Delete Reply'),
            content: const Text('Are you sure you want to delete this reply?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  replyController.deleteReply(reply.id);
                  Get.back();
                },
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        break;
      case 'report':
        Get.snackbar('Reported', 'Reply has been reported');
        break;
    }
  }
}