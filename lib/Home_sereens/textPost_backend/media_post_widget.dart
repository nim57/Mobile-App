import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'post_model.dart';

class MediaPostWidget extends StatefulWidget {
  final PostModel post;

  const MediaPostWidget({super.key, required this.post});

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
    for (int i = 0; i < (widget.post.mediaUrls?.length ?? 0); i++) {
      if (widget.post.mediaTypes?[i] == 'video') {
        _videoControllers[i] = VideoPlayerController.network(
          widget.post.mediaUrls![i]
        )..initialize().then((_) {
          if (mounted) setState(() {});
        });
      }
    }
  }

  void _startAutoScroll() {
    if (widget.post.mediaUrls == null || widget.post.mediaUrls!.isEmpty) return;
    
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isAutoScrolling) return;
      
      if (_currentPage < widget.post.mediaUrls!.length - 1) {
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
    final mediaUrls = widget.post.mediaUrls ?? [];
    if (mediaUrls.isEmpty) return const SizedBox();

    return GestureDetector(
      onDoubleTap: _toggleAutoScroll,
      child: SizedBox(
        height: 400,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: mediaUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                
                // Pause all videos except current
                for (int i = 0; i < mediaUrls.length; i++) {
                  if (i != index && _videoControllers.containsKey(i)) {
                    _videoControllers[i]!.pause();
                  }
                }
              },
              itemBuilder: (context, index) {
                final mediaType = widget.post.mediaTypes?[index] ?? 'image';
                
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
                    mediaUrls[index],
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
                children: List.generate(mediaUrls.length, (index) {
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