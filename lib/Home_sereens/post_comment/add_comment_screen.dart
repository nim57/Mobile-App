import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'post_comment_controller.dart';
import 'post_comment_model.dart';

class AddCommentScreen extends StatefulWidget {
  final String postId;
  final bool hasMedia;
  final bool isEditing;
  final PostCommentModel? comment;

  const AddCommentScreen({
    super.key,
    required this.postId,
    this.hasMedia = false,
    this.isEditing = false,
    this.comment,
  });

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final PostCommentController _controller = Get.find();
  final TextEditingController _contentController = TextEditingController();
  final RxList<AssetEntity> _selectedMedia = <AssetEntity>[].obs;
  final RxBool _profileVisibility = true.obs;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.comment != null) {
      _contentController.text = widget.comment!.content;
      _profileVisibility.value = widget.comment!.profileVisibility;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Comment' : 'Add Comment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitComment,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Write your comment...',
                border: InputBorder.none,
              ),
              maxLines: 5,
            ),
            
            if (widget.hasMedia) ...[
              const SizedBox(height: 20),
              Obx(() => _buildMediaPreview()),
              IconButton(
                icon: const Icon(Icons.add_photo_alternate),
                onPressed: _pickMedia,
              ),
            ],
            
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Profile Visibility:'),
                const SizedBox(width: 10),
                Obx(() => Switch(
                  value: _profileVisibility.value,
                  onChanged: (value) => _profileVisibility.value = value,
                )),
                const SizedBox(width: 10),
                Obx(() => Text(
                  _profileVisibility.value ? 'Visible' : 'Hidden',
                  style: TextStyle(
                    color: _profileVisibility.value ? Colors.green : Colors.grey,
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedMedia.length,
        itemBuilder: (context, index) {
          return FutureBuilder<Uint8List?>(
            future: _selectedMedia[index].thumbnailData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              } else {
                return const SizedBox(width: 100, height: 100, child: Center(child: CircularProgressIndicator()));
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _pickMedia() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
      if (albums.isNotEmpty) {
        final List<AssetEntity> media = await albums.first.getAssetListPaged(page: 0, size: 100);
        // Show media picker UI here
      }
    }
  }

  void _submitComment() {
    if (_contentController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter comment text');
      return;
    }
    
    if (widget.isEditing && widget.comment != null) {
      _controller.updateComment(
        widget.comment!,
        _contentController.text,
      );
    } else {
      _controller.addComment(
        postId: widget.postId,
        content: _contentController.text,
        mediaFiles: _selectedMedia,
        profileVisibility: _profileVisibility.value,
      );
    }
    
    Get.back();
  }
}