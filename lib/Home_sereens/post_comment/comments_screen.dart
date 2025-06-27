import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_project_123/Home_sereens/textPost_backend/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../post_reply/add_reply_screen.dart';
import '../post_reply/post_reply_controller.dart';
import '../post_reply/post_reply_model.dart';
import 'add_comment_screen.dart';
import 'post_comment_controller.dart';
import 'post_comment_model.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId, required PostModel post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final PostCommentController _commentController =
      Get.put(PostCommentController());
  final PostReplyController _replyController = Get.put(PostReplyController());
  final TextEditingController _commentTextController = TextEditingController();
  final UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    _commentController.loadCommentsForPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_commentController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_commentController.error.value.isNotEmpty) {
                return Center(child: Text(_commentController.error.value));
              }

              return ListView.builder(
                itemCount: _commentController.comments.length,
                itemBuilder: (context, index) {
                  final comment = _commentController.comments[index];
                  return _buildCommentItem(comment);
                },
              );
            }),
          ),
          _buildAddCommentSection(),
        ],
      ),
    );
  }

  Widget _buildCommentItem(PostCommentModel comment) {
    final isCurrentUser = _userController.user.value.id == comment.userId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.userProfilePic),
            radius: 20,
          ),
          title: Text(comment.userName),
          subtitle: Text(comment.timestamp.toDate().toString()),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => _handleCommentMenu(value, comment),
            itemBuilder: (context) => [
              if (isCurrentUser) ...[
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              const PopupMenuItem(value: 'report', child: Text('Report')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(comment.content),
        ),

        // Comment media
        if (comment.mediaUrls != null && comment.mediaUrls!.isNotEmpty)
          _buildCommentMedia(comment.mediaUrls!, comment.mediaTypes!),

        // Reply button
        TextButton(
          onPressed: () => _showReplies(comment),
          child: const Text('Reply'),
        ),

        const Divider(),
      ],
    );
  }

  Widget _buildCommentMedia(List<String> mediaUrls, List<String> mediaTypes) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaUrls.length,
        itemBuilder: (context, index) {
          if (mediaTypes[index] == 'video') {
            return _buildVideoPlayer(mediaUrls[index]);
          } else {
            return Image.network(
              mediaUrls[index],
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.error)),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildVideoPlayer(String url) {
    return FutureBuilder(
      future: VideoPlayerController.network(url).initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final controller = snapshot.data as VideoPlayerController;
          return AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          );
        } else {
          return const SizedBox(
              width: 200,
              height: 200,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  void _showReplies(PostCommentModel comment) {
    _replyController.fetchReplies(comment.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Replies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: Obx(() {
                  if (_replyController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: _replyController.replies.length,
                    itemBuilder: (context, index) {
                      final reply = _replyController.replies[index];
                      return _buildReplyItem(reply);
                    },
                  );
                }),
              ),
              _buildAddReplySection(comment), // Pass comment object
            ],
          ),
        );
      },
    );
  }

  Widget _buildReplyItem(PostReplyModel reply) {
    final isCurrentUser = _userController.user.value.id == reply.userId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(reply.userProfilePic),
            radius: 20,
          ),
          title: Text(reply.userName),
          subtitle: Text(reply.timestamp.toDate().toString()),
          trailing: PopupMenuButton<String>(
            onSelected: (value) => _handleReplyMenu(value, reply),
            itemBuilder: (context) => [
              if (isCurrentUser) ...[
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              const PopupMenuItem(value: 'report', child: Text('Report')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(reply.content),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildAddCommentSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentTextController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => _navigateToAddCommentScreen(true),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_commentTextController.text.isNotEmpty) {
                _commentController.addComment(
                  postId: widget.postId,
                  content: _commentTextController.text,
                  profileVisibility: true,
                );
                _commentTextController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddReplySection(PostCommentModel comment) {
    final replyTextController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: replyTextController,
              decoration: const InputDecoration(
                hintText: 'Add a reply...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => Get.to(() => AddReplyScreen(
                  comment: comment,
                  hasMedia: true,
                )),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (replyTextController.text.isNotEmpty) {
                _replyController.addReply(
                  commentId: comment.id,
                  content: replyTextController.text,
                  profileVisibility: true,
                );
                replyTextController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _navigateToAddCommentScreen(bool hasMedia) {
    Get.to(() => AddCommentScreen(
          postId: widget.postId,
          hasMedia: hasMedia,
        ));
  }

  void _handleCommentMenu(String value, PostCommentModel comment) {
    switch (value) {
      case 'edit':
        _navigateToEditCommentScreen(comment);
        break;
      case 'delete':
        _showDeleteCommentConfirmation(comment.id);
        break;
      case 'report':
        _reportComment(comment.id);
        break;
    }
  }

  void _handleReplyMenu(String value, PostReplyModel reply) {
    switch (value) {
      case 'edit':
        _navigateToEditReplyScreen(reply);
        break;
      case 'delete':
        _showDeleteReplyConfirmation(reply.id);
        break;
      case 'report':
        _reportReply(reply.id);
        break;
    }
  }

  void _navigateToEditCommentScreen(PostCommentModel comment) {
    Get.to(() => AddCommentScreen(
          postId: widget.postId,
          isEditing: true,
          comment: comment,
        ));
  }

  void _navigateToEditReplyScreen(PostReplyModel reply) {
    // Create a dummy comment since we only need the ID
    final dummyComment = PostCommentModel(
      id: reply.commentId,
      postId: '',
      userId: '',
      userName: '',
      userProfilePic: '',
      content: '',
      profileVisibility: true,
      timestamp: Timestamp.now(),
      mediaUrls: null,
      mediaTypes: null,
    );

    Get.to(() => AddReplyScreen(
          comment: dummyComment,
          reply: reply,
          isEditing: true,
        ));
  }

  void _showDeleteCommentConfirmation(String commentId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _commentController.deleteComment(commentId);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteReplyConfirmation(String replyId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Reply'),
        content: const Text('Are you sure you want to delete this reply?'),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _replyController.deleteReply(replyId);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _reportComment(String commentId) {
    Get.snackbar('Reported', 'Comment has been reported');
  }

  void _reportReply(String replyId) {
    Get.snackbar('Reported', 'Reply has been reported');
  }
}