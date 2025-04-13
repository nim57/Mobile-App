import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import '../../Utils/constants/image_strings.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../comment_backend/comment_controller.dart';
import '../comment_backend/comment_model.dart';
import '../comment_backend/comment_tile.dart';
import '../review_backend/review_controler.dart';
import '../review_backend/review_model.dart';
import '../widgets/following_page/emoji_box.dart';
import '../widgets/following_page/profile_pic.dart';
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
              if (_showReplyBox) _buildReplyBox(),
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

  Widget _buildListItem(dynamic item) {
    if (item is ReviewModel)
      return _ReviewTile(review: item, onReply: _toggleReplyBox);
    if (item is CommentModel) return CommentTile(comment: item);
    return const SizedBox.shrink();
  }

  Widget _buildReplyBox() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _replyController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon:
                      _selectedEmoji != null ? Text(_selectedEmoji!) : null,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () => _pickMedia(ImageSource.gallery),
            ),
            IconButton(
              icon: const Icon(Icons.emoji_emotions),
              onPressed: _pickEmoji,
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _replyController.clear();
                _toggleReplyBox();
              },
            ),
          ],
        ),
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
      ],
    );
  }
}

class _UserHeader extends StatelessWidget {
  final ReviewModel review;

  const _UserHeader({required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: review.userProfile.isNotEmpty
              ? NetworkImage(review.userProfile)
              : const AssetImage(
                      'Assets/App_Assets/authentication_assets/user1.png')
                  as ImageProvider,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review.username),
            Text(
              ReviewController.instance.getTimeAgo(review.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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
