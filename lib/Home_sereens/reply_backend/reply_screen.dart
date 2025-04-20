import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import 'reply_controller.dart';

class ReplySection extends StatefulWidget {
  final String parentId;
  final String itemId;
  final VoidCallback onClose;

  const ReplySection({
    super.key,
    required this.parentId,
    required this.itemId,
    required this.onClose,
  });

  @override
  State<ReplySection> createState() => _ReplySectionState();
}

class _ReplySectionState extends State<ReplySection> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();
  final ReplyController _controller = Get.find<ReplyController>();

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildInputSection(context),
          Obx(() => _controller.selectedMedia.isNotEmpty
              ? _buildMediaPreview()
              : const SizedBox.shrink()),
          _buildEmojiPicker(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        const Text('New Reply', style: TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onClose,
        ),
      ],
    ),
  );

  Widget _buildInputSection(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      children: [
        TextField(
          controller: _textController,
          focusNode: _textFocus,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write your reply...',
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: _toggleEmojiPicker,
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () => _controller.pickMultipleMedia(),
                ),
              ],
            ),
          ),
          onChanged: (value) => _textController.text = value,
        ),
        _buildActionBar(context),
      ],
    ),
  );

  Widget _buildActionBar(BuildContext context) => Obx(() => Row(
    children: [
      const Text('Visible to Public'),
      Switch(
        value: _controller.isVisible.value,
        onChanged: _controller.toggleVisibility,
        activeColor: Theme.of(context).primaryColor,
      ),
      const Spacer(),
      if (_controller.isLoading.value)
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      else
        TextButton(
          onPressed: _submitReply,
          child: const Text('Send'),
        ),
    ],
  ));

  Widget _buildMediaPreview() => SizedBox(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _controller.selectedMedia.length,
      itemBuilder: (context, index) => _mediaItem(index),
    ),
  );

  Widget _mediaItem(int index) => Stack(
    children: [
      Container(
        margin: const EdgeInsets.all(4),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: FileImage(File(_controller.selectedMedia[index].path)),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        right: 0,
        child: IconButton(
          icon: const Icon(Icons.close, size: 20),
          color: Colors.white,
          onPressed: () => _controller.removeMedia(index),
        ),
      ),
    ],
  );

  Widget _buildEmojiPicker() => Obx(() => AnimatedSize(
    duration: const Duration(milliseconds: 300),
    child: _controller.showEmojiPicker.value
        ? SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                final text = _textController.text;
                final selection = _textController.selection;
                final newText = text.replaceRange(
                  selection.start,
                  selection.end,
                  emoji.emoji,
                );
                _textController.text = newText;
                _textController.selection = selection.copyWith(
                  baseOffset: selection.start + emoji.emoji.length,
                  extentOffset: selection.start + emoji.emoji.length,
                );
              },
              config: const Config(
                emojiViewConfig: EmojiViewConfig(
                  columns: 7,
                  emojiSizeMax: 32,
                ),
              ),
            ),
          )
        : const SizedBox.shrink(),
  ));

  void _toggleEmojiPicker() {
    if (_controller.showEmojiPicker.value) {
      _textFocus.requestFocus();
    } else {
      final currentText = _textController.text;
      _textFocus.unfocus();
      _textController.text = currentText;
    }
    _controller.toggleEmojiPicker();
  }

  void _submitReply() {
    final user = Get.find<UserController>().user.value;

    if (_textController.text.isEmpty && _controller.selectedMedia.isEmpty) {
      Get.snackbar('Empty Content', 'Please enter text or attach media');
      return;
    }

    _controller.submitReply(
      text: _textController.text,
      parentId: widget.parentId,
      itemId: widget.itemId,
      authorId: user.id,
      authorName: user.username,
      authorEmail: user.email,
      prefecture: user.profilePicture,
    );
    _textController.clear();
    widget.onClose();
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