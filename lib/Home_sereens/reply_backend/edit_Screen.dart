// edit_reply_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echo_project_123/Home_sereens/reply_backend/reply_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reply_controller.dart';

class EditReplyScreen extends StatelessWidget {
  final ReplyModel reply;
  final TextEditingController _textController = TextEditingController();
  final ReplyController _controller = Get.find<ReplyController>();

  EditReplyScreen({super.key, required this.reply}) {
    _textController.text = reply.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Reply'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildExistingMedia(),
              TextField(
                controller: _textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Edit your reply...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _buildMediaButtons(),
              const SizedBox(height: 16),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingMedia() {
    return Obx(() => Wrap(
      spacing: 8,
      children: _controller.existingMediaUrls.map((url) => Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 16),
              color: Colors.white,
              onPressed: () => _controller.existingMediaUrls.remove(url),
            ),
          ),
        ],
      )).toList(),
    ));
  }

  Widget _buildMediaButtons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.photo_library),
          onPressed: () => _controller.pickMultipleMedia(),
        ),
        Obx(() => Text(
          '${_controller.selectedMedia.length} new media selected',
          style: const TextStyle(color: Colors.grey),
        )),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Obx(() => _controller.isLoading.value
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: _submitUpdate,
            child: const Text('Update Reply'),
          ));
  }

  void _submitUpdate() {
    if (_textController.text.isEmpty && 
        _controller.existingMediaUrls.isEmpty &&
        _controller.selectedMedia.isEmpty) {
      Get.snackbar('Error', 'Reply cannot be empty');
      return;
    }

    _controller.updateReply(
      replyId: reply.replyId,
      text: _textController.text,
    );
    Get.back();
  }
}