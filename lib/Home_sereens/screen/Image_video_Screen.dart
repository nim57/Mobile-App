import 'dart:typed_data';
import 'package:echo_project_123/Home_sereens/textPost_backend/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageVideoScreen extends StatefulWidget {
  const ImageVideoScreen({super.key});

  @override
  State<ImageVideoScreen> createState() => _ImageVideoScreenState();
}

class _ImageVideoScreenState extends State<ImageVideoScreen> {
  final PostController _mediaPostController = Get.put(PostController());
  List<AssetPathEntity> _folders = [];
  List<AssetEntity> _mediaFiles = [];
  AssetPathEntity? _selectedFolder;
  final List<AssetEntity> _selectedMedia = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    setState(() => _isLoading = true);
    
    var permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      List<AssetPathEntity> folders = await PhotoManager.getAssetPathList(
        type: RequestType.common,
      );

      setState(() {
        _folders = folders;
        if (folders.isNotEmpty) {
          _selectedFolder = folders[0];
          _loadMediaFiles();
        }
      });
    } else {
      // Handle permission denied
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMediaFiles() async {
    if (_selectedFolder != null) {
      List<AssetEntity> mediaFiles = await _selectedFolder!.getAssetListPaged(
        page: 0,
        size: 100,
      );
      setState(() {
        _mediaFiles = mediaFiles;
        _isLoading = false;
      });
    }
  }

  void _onFolderSelected(AssetPathEntity folder) {
    setState(() {
      _selectedFolder = folder;
      _isLoading = true;
    });
    _loadMediaFiles();
  }

  void _toggleMediaSelection(AssetEntity media) {
    setState(() {
      if (_selectedMedia.contains(media)) {
        _selectedMedia.remove(media);
      } else {
        _selectedMedia.add(media);
      }
    });
  }

  void _navigateToFullScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMediaViewer(
          mediaFiles: _selectedMedia.isNotEmpty ? _selectedMedia : _mediaFiles,
          initialIndex: index,
          onSelectionChanged: _selectedMedia.isNotEmpty ? _toggleMediaSelection : null,
        ),
      ),
    );
  }

  void _uploadPost() {
    if (_selectedMedia.isEmpty) {
      Get.snackbar('Error', 'Please select at least one media file');
      return;
    }
    
    _mediaPostController.uploadMediaPost(_selectedMedia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: DropdownButton<AssetPathEntity>(
                value: _selectedFolder,
                isExpanded: true,
                underline: const SizedBox(),
                items: _folders.map((folder) {
                  return DropdownMenuItem(
                    value: folder,
                    child: Text(
                      folder.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _onFolderSelected(value);
                  }
                },
              ),
            ),
            if (_selectedMedia.isNotEmpty)
              Text(
                '${_selectedMedia.length} Selected',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          if (_selectedMedia.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => _selectedMedia.clear()),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _mediaFiles.length,
                    itemBuilder: (context, index) {
                      final media = _mediaFiles[index];
                      final isSelected = _selectedMedia.contains(media);
                      
                      return GestureDetector(
                        onTap: () => _toggleMediaSelection(media),
                        onLongPress: () => _navigateToFullScreen(index),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            FutureBuilder<Uint8List?>(
                              future: media.thumbnailData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done &&
                                    snapshot.hasData) {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return Container(color: Colors.grey[300]);
                                }
                              },
                            ),
                            if (media.type == AssetType.video)
                              const Positioned(
                                right: 5,
                                bottom: 5,
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            if (isSelected)
                              Container(
                                color: Colors.black.withOpacity(0.4),
                                child: const Center(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${_selectedMedia.indexOf(media) + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Description and post section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Column(
              children: [
                if (_selectedMedia.isNotEmpty)
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedMedia.length,
                      itemBuilder: (context, index) {
                        final media = _selectedMedia[index];
                        return Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FutureBuilder<Uint8List?>(
                            future: media.thumbnailData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Container(color: Colors.grey[300]);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: _mediaPostController.descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add a description...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  return ElevatedButton(
                    onPressed: _mediaPostController.isUploading.value ? null : _uploadPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _mediaPostController.isUploading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Post',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenMediaViewer extends StatefulWidget {
  final List<AssetEntity> mediaFiles;
  final int initialIndex;
  final Function(AssetEntity)? onSelectionChanged;

  const FullScreenMediaViewer({
    super.key,
    required this.mediaFiles,
    required this.initialIndex,
    this.onSelectionChanged,
  });

  @override
  State<FullScreenMediaViewer> createState() => _FullScreenMediaViewerState();
}

class _FullScreenMediaViewerState extends State<FullScreenMediaViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1}/${widget.mediaFiles.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (widget.onSelectionChanged != null)
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.white),
              onPressed: () => widget.onSelectionChanged?.call(widget.mediaFiles[_currentIndex]),
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaFiles.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final media = widget.mediaFiles[index];
          return FutureBuilder<Uint8List?>(
            future: media.file.then((file) => file?.readAsBytes()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Center(
                  child: media.type == AssetType.image
                      ? Image.memory(
                          snapshot.data!,
                          fit: BoxFit.contain,
                        )
                      : const Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 100,
                        ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}