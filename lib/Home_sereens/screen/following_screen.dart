import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/constants/sizes.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../post_comment/comments_screen.dart';
import '../textPost_backend/edit_text_post_screen.dart';
import '../textPost_backend/post_controller.dart';
import '../textPost_backend/post_list_controller.dart';
import '../textPost_backend/post_model.dart';
import 'Add_new_post.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostListController _postListController = Get.put(PostListController());
  final PostController _postController = Get.put(PostController());
  final UserController _userController = Get.find();
  final List<String> reactions = ["👍", "❤️", "😂", "😮", "😢", "😡"];
  String selectedReaction = "❤️";
  bool showAllReactions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<PostModel>>(
        stream: _postListController.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.post_add, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No posts yet',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Be the first to share something!',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _buildPostItem(post);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddNewPost()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPostItem(PostModel post) {
    final isCurrentUser = _userController.user.value.id == post.userId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User info
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(post.userProfilePic),
                radius: 20,
              ),
              const SizedBox(width: ESizes.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      _postListController.formatTime(post.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Options menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 24),
                onSelected: (value) => _handleMenuSelection(value, post),
                itemBuilder: (context) {
                  if (isCurrentUser) {
                    return [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
                    ];
                  } else {
                    return [
                      const PopupMenuItem(
                          value: 'report', child: Text('Report')),
                    ];
                  }
                },
              ),
            ],
          ),
        ),

        // Description
        if (post.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(post.description),
          ),

        const SizedBox(height: 10),

        // Post content
        if (post.type == PostType.text)
          _buildTextPost(post)
        else
          _buildMediaPost(post),

        // Reactions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              // Reaction selector
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (showAllReactions)
                    Positioned(
                      bottom: 40,
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: reactions.map((reaction) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedReaction = reaction;
                                    showAllReactions = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    reaction,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  // Selected reaction
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAllReactions = !showAllReactions;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        selectedReaction,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Comments
              IconButton(
                icon: const Icon(Iconsax.message, size: 24),
                onPressed: () => Get.to(() => CommentsScreen(post: post, postId: '',)),
              ),
              const SizedBox(width: 4),
              const Text('24'),

              const SizedBox(width: 16),

              // Views
              const Icon(Iconsax.eye, size: 24),
              const SizedBox(width: 4),
              const Text('1.2k'),
            ],
          ),
        ),

        const Divider(),
      ],
    );
  }

  Widget _buildTextPost(PostModel post) {
    // Parse background color
    Color bgColor;
    try {
      bgColor = Color(int.parse(post.backgroundColor!, radix: 16));
    } catch (e) {
      bgColor = Colors.blue;
    }

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          post.textContent ?? '',
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ).merge(_parseTextStyle(post.textStyle)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Simple text style parser
  TextStyle _parseTextStyle(String? styleString) {
    if (styleString == null) return const TextStyle();

    return TextStyle(
      fontWeight: styleString.contains('FontWeight.bold')
          ? FontWeight.bold
          : FontWeight.normal,
      fontStyle: styleString.contains('FontStyle.italic')
          ? FontStyle.italic
          : FontStyle.normal,
      decoration: styleString.contains('TextDecoration.underline')
          ? TextDecoration.underline
          : styleString.contains('TextDecoration.lineThrough')
              ? TextDecoration.lineThrough
              : TextDecoration.none,
    );
  }

  Widget _buildMediaPost(PostModel post) {
    return MediaPostWidget(
        mediaUrls: post.mediaUrls ?? [], mediaTypes: post.mediaTypes ?? []);
  }

  void _handleMenuSelection(String value, PostModel post) {
    switch (value) {
      case 'edit':
        _navigateToEditScreen(post);
        break;
      case 'delete':
        _showDeleteConfirmation(post);
        break;
      case 'report':
        _reportPost(post);
        break;
    }
  }

  void _navigateToEditScreen(PostModel post) {
    if (post.type == PostType.text) {
      Get.to(() => EditTextPostScreen(post: post));
    } else {
      // For media posts, we can only edit description
      // You can implement a similar screen for media posts
      Get.snackbar(
          'Info', 'Media posts can only be edited in the next version');
    }
  }

  void _showDeleteConfirmation(PostModel post) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
            'Are you sure you want to delete this post permanently?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _postController.deletePost(post);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _reportPost(PostModel post) {
    Get.dialog(
      AlertDialog(
        title: const Text('Report Post'),
        content: const Text('Why are you reporting this post?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Reported',
                  'Thank you for your report. We will review it shortly.');
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class MediaPostWidget extends StatefulWidget {
  final List<String> mediaUrls;
  final List<String> mediaTypes;

  const MediaPostWidget({
    super.key,
    required this.mediaUrls,
    required this.mediaTypes,
  });

  @override
  State<MediaPostWidget> createState() => _MediaPostWidgetState();
}

class _MediaPostWidgetState extends State<MediaPostWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  bool _isAutoScrolling = true;
  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();

    // Initialize video controllers
    for (int i = 0; i < widget.mediaUrls.length; i++) {
      if (widget.mediaTypes[i] == 'video') {
        _videoControllers[i] =
            VideoPlayerController.network(widget.mediaUrls[i])
              ..initialize().then((_) {
                if (mounted) setState(() {});
              });
      }
    }
  }

  void _startAutoScroll() {
    if (widget.mediaUrls.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isAutoScrolling) return;

      if (_currentPage < widget.mediaUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _toggleAutoScroll() {
    setState(() {
      _isAutoScrolling = !_isAutoScrolling;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaUrls.isEmpty) return const SizedBox();

    return GestureDetector(
      onDoubleTap: _toggleAutoScroll,
      child: SizedBox(
        height: 400,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });

                // Pause all videos except current
                for (int i = 0; i < widget.mediaUrls.length; i++) {
                  if (i != index && _videoControllers.containsKey(i)) {
                    _videoControllers[i]!.pause();
                  }
                }
              },
              itemBuilder: (context, index) {
                final mediaType = widget.mediaTypes[index];

                if (mediaType == 'video') {
                  final controller = _videoControllers[index];
                  if (controller == null || !controller.value.isInitialized) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GestureDetector(
                    onTap: () {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }
                      setState(() {});
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                        if (!controller.value.isPlaying)
                          const Icon(Icons.play_circle_filled,
                              size: 60, color: Colors.white70),
                      ],
                    ),
                  );
                } else {
                  return Image.network(
                    widget.mediaUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  );
                }
              },
            ),

            // Position indicators
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.mediaUrls.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),

            // Auto-scroll status indicator
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isAutoScrolling ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isAutoScrolling ? 'Auto' : 'Manual',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
