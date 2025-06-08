// comment_tile.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../screen/Comment&ReviewScreen.dart';
import 'comment_controller.dart';
import 'comment_model.dart';
import '../reply_backend/reply_controller.dart';
import '../reply_backend/reply_model.dart';
import '../reply_backend/reply_repository.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onReply;

  const CommentTile({
    super.key,
    required this.comment,
    required this.onReply,
  });

  ImageProvider getProfileImage() {
    if (comment.isVisible) {
      return comment.userProfile.isNotEmpty
          ? NetworkImage(comment.userProfile)
          : const AssetImage(
              'Assets/App_Assets/authentication_assets/user1.png');
    }
    return const AssetImage(
        'Assets/App_Assets/authentication_assets/auth2.png');
  }

  @override
  Widget build(BuildContext context) {
    final replyController = Get.find<ReplyController>();
    final userController = Get.find<UserController>();
    final isCurrentUser = userController.user.value.id == comment.userId;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _userHeader(context),
        const SizedBox(height: 16),
        Text(comment.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(comment.text),
          _buildSentimentIndicator(),
        const SizedBox(height: 12),
        _tags(),
        _actionButtons(),
        _buildRepliesSection(replyController),
      ],
    );
  }


  /// sentiment analysis indicator
   Widget _buildSentimentIndicator() {
    final sentiment = comment.sentiment;
    
    if (sentiment == null) {
      return Row(
        children: [
          const Text('Analyzing sentiment... '),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      );
    }
    
    return Row(
      children: [
        Icon(
          sentiment == 'positive'
            ? Icons.sentiment_satisfied
            : Icons.sentiment_dissatisfied,
          color: sentiment == 'positive' ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          'Sentiment: ${sentiment.toUpperCase()}',
          style: TextStyle(
            color: sentiment == 'positive' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  ///dddddddddddddddddd

  Widget _userHeader(BuildContext context) {
    final userController = Get.find<UserController>();
    final isCurrentUser = userController.user.value.id == comment.userId;
    return Row(
      children: [
              if (isCurrentUser) _buildDeleteMenu(context),
        CircleAvatar(backgroundImage: getProfileImage()),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.isVisible ? comment.username : 'Anonymous',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              CommentController.instance.getTimeAgo(comment.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        if (isCurrentUser) _buildDeleteMenu(context),
      ],
    );
  }

  Widget _buildDeleteMenu(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete Comment', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
      onSelected: (value) => _showDeleteConfirmation(context),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text(
            'Are you sure you want to delete this comment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<CommentController>().deleteComment(comment.commentId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _tags() => Wrap(
        spacing: 8,
        children: comment.tags
            .map((tag) => Chip(
                  label: Text('#$tag'),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ))
            .toList(),
      );

  Widget _actionButtons() => Row(
        children: [
          IconButton(icon: const Icon(Icons.thumb_up), onPressed: () {}),
          const Text('0'),
          const SizedBox(width: 16),
          IconButton(icon: const Icon(Icons.thumb_down), onPressed: () {}),
          const Text('0'),
          const Spacer(),
          TextButton(onPressed: onReply, child: const Text("Reply")),
        ],
      );

  Widget _buildRepliesSection(ReplyController controller) {
    return StreamBuilder<List<ReplyModel>>(
      stream: ReplyRepository().getReplies(comment.commentId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        final replies = snapshot.data!;
        if (replies.isEmpty) return const SizedBox.shrink();

        final isExpanded =
            controller.expandedReplies[comment.commentId] ?? false;
        final visibleReplies = isExpanded ? replies : replies.take(1).toList();

        return Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Column(
            children: [
              ...visibleReplies.map((reply) => ReplyTile(
                    reply: reply,
                    isLast: reply == visibleReplies.last,
                  )),
              if (replies.length > 1 && !isExpanded)
                _ViewMoreButton(
                  count: replies.length - 1,
                  onTap: () => controller.toggleExpansion(comment.commentId),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewMoreButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _ViewMoreButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      child: Text(
        'View $count more replies',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }
}
