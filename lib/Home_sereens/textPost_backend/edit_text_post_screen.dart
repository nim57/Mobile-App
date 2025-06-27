import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'post_controller.dart';
import 'post_model.dart';

class EditTextPostScreen extends StatefulWidget {
  final PostModel post;

  const EditTextPostScreen({super.key, required this.post});

  @override
  State<EditTextPostScreen> createState() => _EditTextPostScreenState();
}

class _EditTextPostScreenState extends State<EditTextPostScreen> {
  late TextEditingController _descriptionController;
  late TextEditingController _textContentController;
  late Color _backgroundColor;
  late TextStyle _textStyle;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.post.description);
    _textContentController = TextEditingController(text: widget.post.textContent);
    
    try {
      _backgroundColor = Color(int.parse(widget.post.backgroundColor!, radix: 16));
    } catch (e) {
      _backgroundColor = Colors.blue;
    }
    
    _textStyle = _parseTextStyle(widget.post.textStyle);
  }

  TextStyle _parseTextStyle(String? styleString) {
    if (styleString == null) return const TextStyle();
    
    return TextStyle(
      fontWeight: styleString.contains('FontWeight.bold') 
          ? FontWeight.bold : FontWeight.normal,
      fontStyle: styleString.contains('FontStyle.italic') 
          ? FontStyle.italic : FontStyle.normal,
      decoration: styleString.contains('TextDecoration.underline')
          ? TextDecoration.underline
          : styleString.contains('TextDecoration.lineThrough')
            ? TextDecoration.lineThrough
            : TextDecoration.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textContentController,
              decoration: const InputDecoration(
                labelText: 'Text Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Text(
              'Preview:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Container(
              color: _backgroundColor,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  _textContentController.text,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ).merge(_textStyle),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final updatedPost = PostModel(
      userId: widget.post.userId,
      userName: widget.post.userName,
      userProfilePic: widget.post.userProfilePic,
      description: _descriptionController.text.trim(),
      timestamp: widget.post.timestamp,
      type: widget.post.type,
      textContent: _textContentController.text,
      backgroundColor: _backgroundColor.value.toRadixString(16),
      textStyle: _textStyle.toString(),
      mediaUrls: widget.post.mediaUrls,
      mediaTypes: widget.post.mediaTypes,
    );

    final postController = Get.find<PostController>();
    postController.updatePost(widget.post, updatedPost);
    Get.back();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _textContentController.dispose();
    super.dispose();
  }
}