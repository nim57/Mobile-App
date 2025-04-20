import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../comment_backend/comment_controller.dart';
import '../comment_backend/comment_model.dart';
import '../comment_backend/comment_tile.dart';
import '../reply_backend/edit_Screen.dart';
import '../reply_backend/reply_controller.dart';
import '../reply_backend/reply_model.dart';
import '../reply_backend/reply_repository.dart';
import '../reply_backend/reply_screen.dart';
import '../review_backend/review_controler.dart';
import '../review_backend/review_model.dart';
import '../widgets/following_page/emoji_box.dart';
import 'New_replyORCommentScreen.dart';

class CommentReviewScreen extends StatefulWidget {
  final String itemId;
  final String categoryId;

  const CommentReviewScreen({
    super.key,
    required this.itemId,
    required this.categoryId,
  });

  @override
  State<CommentReviewScreen> createState() => _CommentReviewScreenState();
}

class _CommentReviewScreenState extends State<CommentReviewScreen> {
  final ReviewController reviewController = Get.put(ReviewController());
  final CommentController commentController = Get.put(CommentController());
  final ReplyController replyController = Get.put(ReplyController());
  final _replyController = TextEditingController();
  final _emojiParser = EmojiParser();
  bool _showReplyBox = false;
  XFile? _selectedFile;
  String? _selectedEmoji;

  final List<String> _emojis = [
    "😀",
    "😃",
    "😄",
    "😁",
    "😆",
    "😅",
    "😂",
    "🤣",
    "😊",
    "😇",
    "🙂",
    "🙃",
    "😉",
    "😌",
    "😍",
    "🥰",
    "😘",
    "😗",
    "😙",
    "😚"
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    reviewController.fetchReviews(widget.itemId, widget.categoryId);
    commentController.fetchComments(widget.itemId);
  }

  Future<void> _pickMedia(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    setState(() => _selectedFile = pickedFile);
  }

  void _toggleReplyBox() => setState(() => _showReplyBox = !_showReplyBox);

  void _pickEmoji() async {
    final emoji = await showDialog<String>(
      context: context,
      builder: (context) => EmojiPickerDialog(emojis: _emojis),
    );
    if (emoji != null) _replyController.text += emoji;
  }

  void _retry() {
    reviewController.fetchReviews(widget.itemId, widget.categoryId);
    commentController.fetchComments(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(
        showBackArrow: true,
        titlt: Text('Comments & Reviews'),
      ),
      body: Obx(() => Stack(
            children: [
              _buildMainContent(),
              _buildNewReplyButton(),
            ],
          )),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading()) return _loadingIndicator();
    if (_hasError()) return _errorDisplay();
    return _combinedContent();
  }

  bool _isLoading() =>
      reviewController.isLoading.value || commentController.isLoading.value;

  bool _hasError() =>
      reviewController.errorMessage.isNotEmpty ||
      commentController.errorMessage.isNotEmpty;

  Widget _loadingIndicator() =>
      const Center(child: CircularProgressIndicator());

  Widget _errorDisplay() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(reviewController.errorMessage.value),
            Text(commentController.errorMessage.value),
            ElevatedButton(
              onPressed: _retry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );

  Widget _combinedContent() {
    final combined = [
      ...reviewController.reviews,
      ...commentController.comments
    ];
    combined.sort((a, b) {
      final aTime =
          a is ReviewModel ? a.timestamp : (a as CommentModel).timestamp;
      final bTime =
          b is ReviewModel ? b.timestamp : (b as CommentModel).timestamp;
      return bTime.compareTo(aTime);
    });
    return Column(
      children: [
        _headerInfo(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: combined.length,
            separatorBuilder: (_, __) => const Divider(height: 40),
            itemBuilder: (context, index) => _buildListItem(combined[index]),
          ),
        ),
      ],
    );
  }

  Widget _headerInfo() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${reviewController.categoryName} / ${reviewController.itemName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${reviewController.reviews.length} reviews • ${commentController.comments.length} comments',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );

  // In your CommentReviewScreen widget
  Widget _buildListItem(dynamic item) {
    if (item is ReviewModel) {
      return _ReviewTile(
        review: item,
        onReply: () => _handleReplyPress(item.reviewId),
      );
    }
    if (item is CommentModel) {
      return CommentTile(
        comment: item,
        onReply: () => _handleCommentReplyPress(item.commentId),
      );
    }
    return const SizedBox.shrink();
  }

  void _handleCommentReplyPress(String commentId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReplySection(
        parentId: commentId,
        itemId: widget.itemId,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _handleReplyPress(String parentId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReplySection(
        parentId: parentId,
        itemId: widget.itemId,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildNewReplyButton() => Positioned(
        bottom: 70,
        right: 20,
        child: FloatingActionButton(
          onPressed: () => Get.to(
            () => New_replyROComment(
              categoryId: widget.categoryId,
              itemId: widget.itemId,
            ),
          ),
          child: const Icon(Iconsax.add),
        ),
      );
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  final VoidCallback onReply;

  const _ReviewTile({
    required this.review,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final replyController = Get.find<ReplyController>();
    final userController = Get.find<UserController>();
    final isCurrentUser = userController.user.value.id == review.userId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UserHeader(review: review),
        const SizedBox(height: 16),
        _RatingBars(ratings: review.ratings),
        const SizedBox(height: 16),
        Text(review.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _CommentText(comment: review.comment),
        const SizedBox(height: 12),
        _ReviewTags(tags: review.tags),
        _InteractionButtons(onReply: onReply),
        _buildRepliesSection(replyController),
      ],
    );
  }

  Widget _buildRepliesSection(ReplyController controller) {
    return StreamBuilder<List<ReplyModel>>(
      stream: ReplyRepository().getReplies(review.reviewId),
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

        final isExpanded = controller.expandedReplies[review.reviewId] ?? false;
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
                  onTap: () => controller.toggleExpansion(review.reviewId),
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

class ReplyTile extends StatelessWidget {
  final ReplyModel reply;
  final bool isLast;

  const ReplyTile({super.key, required this.reply, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.grey.shade300,
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildContent(context),
          _buildMedia(),
          _buildInteractionBar(),
          if (!isLast) const Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final userController = Get.find<UserController>();
    final isCurrentUser = userController.user.value.id == reply.authorId;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider(reply.authorName),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reply.authorName,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) _buildMenuButton(context),
                  ],
                ),
                Text(
                  Get.find<ReplyController>().getTimeAgo(reply.timestamp),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onSelected: (value) => _handleMenuSelection(value, context),
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.edit, size: 20),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.delete, size: 20, color: Colors.red),
            title: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        reply.text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildMedia() {
    if (reply.mediaUrls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reply.mediaUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final url = reply.mediaUrls[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: url,
              width: 100,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractionBar() {
    return Row(
      children: [
        Obx(() {
          final controller = Get.find<ReplyController>();
          final likes = controller.likedReplies[reply.replyId] ?? 0;
          return Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  size: 18,
                  color: controller.userLikes[reply.replyId] == true
                      ? Colors.blue
                      : Colors.grey,
                ),
                onPressed: () => controller.toggleLike(reply.replyId),
              ),
              Text('$likes'),
            ],
          );
        }),
        const SizedBox(width: 16),
        Obx(() {
          final controller = Get.find<ReplyController>();
          final dislikes = controller.dislikedReplies[reply.replyId] ?? 0;
          return Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_down,
                  size: 18,
                  color: controller.userDislikes[reply.replyId] == true
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () => controller.toggleDislike(reply.replyId),
              ),
              Text('$dislikes'),
            ],
          );
        }),
      ],
    );
  }

  void _handleMenuSelection(String value, BuildContext context) {
    switch (value) {
      case 'edit':
        _navigateToEditScreen(context);
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _showDeleteConfirmation() {
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
              Get.back();
              Get.find<ReplyController>().deleteReply(reply.replyId);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context) {
    final controller = Get.find<ReplyController>();
    controller.startEditing(reply);
    Get.to(() => EditReplyScreen(reply: reply));
  }

  void _handleDelete() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this reply?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                await Get.find<ReplyController>().deleteReply(reply.replyId);
                Get.snackbar('Success', 'Reply deleted successfully');
              } catch (e) {
                Get.snackbar(
                    'Error', 'Failed to delete reply: ${e.toString()}');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final ReviewModel review;

  _UserHeader({required this.review});
  final userController = Get.find<UserController>();
  final isCurrentUser = true;

  // Helper function to get the appropriate profile image
  ImageProvider getProfileImage() {
    if (review.isVisible == true) {
      return review.userProfile.isNotEmpty
          ? NetworkImage(review.userProfile)
          : const AssetImage(
              'Assets/App_Assets/authentication_assets/user1.png');
    }
    return const AssetImage(
        'Assets/App_Assets/authentication_assets/auth2.png');
  }

  Widget _buildDeleteMenu(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete Review', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
      onSelected: (value) => _showDeleteConfirmation(context),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Review'),
        content: const Text(
            'Are you sure you want to delete this review? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.find<ReviewController>().deleteReview(review.reviewId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: getProfileImage(),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.isVisible == true ? review.username : 'Anonymous',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              ReviewController.instance.getTimeAgo(review.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        if (isCurrentUser) _buildDeleteMenu(context),
      ],
    );
  }
}

class _RatingBars extends StatelessWidget {
  final Map<String, double> ratings;

  const _RatingBars({required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ratings.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(entry.key)),
              Expanded(
                flex: 3,
                child: LinearProgressIndicator(
                  value: entry.value / 5,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${entry.value.toStringAsFixed(1)}/5'),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CommentText extends StatefulWidget {
  final String comment;

  const _CommentText({required this.comment});

  @override
  State<_CommentText> createState() => _CommentTextState();
}

class _CommentTextState extends State<_CommentText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.comment,
          style: Theme.of(context).textTheme.bodyMedium,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 8,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return Text(widget.comment);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _expanded
                  ? widget.comment
                  : '${widget.comment.substring(0, 200)}...',
            ),
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Show less' : 'Show more'),
            ),
          ],
        );
      },
    );
  }
}

class _ReviewTags extends StatelessWidget {
  final List<String> tags;

  const _ReviewTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: tags
          .map((tag) => Chip(
                label: Text('#$tag'),
                padding: EdgeInsets.zero,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
              ))
          .toList(),
    );
  }
}

class _InteractionButtons extends StatelessWidget {
  final VoidCallback onReply;

  const _InteractionButtons({required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Iconsax.like_1),
          onPressed: () {},
        ),
        const Text('0'),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Iconsax.dislike),
          onPressed: () {},
        ),
        const Text('0'),
        const Spacer(),
        TextButton(
          onPressed: onReply,
          child: const Text("Reply"),
        ),
      ],
    );
  }

  /// comment itle
}
