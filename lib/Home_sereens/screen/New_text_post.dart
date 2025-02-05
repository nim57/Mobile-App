import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NewTextPost extends StatefulWidget {
  const NewTextPost({super.key});

  @override
  State<NewTextPost> createState() => _NewTextPostState();
}

class _NewTextPostState extends State<NewTextPost> {
  bool _isEditing = false;
  final TextEditingController _textController = TextEditingController();
  String _typedText = '';

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _addEmoji(String emoji) {
    _textController.text += emoji;
    _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _toggleEditing,
                  icon: Icon(Iconsax.text, color: Colors.white, size: 30),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {}, // Add your paint bucket functionality here
                  icon: Icon(Iconsax.paintbucket, color: Colors.white, size: 30),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    _addEmoji('😊'); // Example emoji addition
                  },
                  icon: Icon(Iconsax.emoji_happy, color: Colors.white, size: 30),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250),
            child: _isEditing
                ? TextFormField(
              controller: _textController,
              style: TextStyle(color: Colors.white70, fontSize: 25),
              decoration: InputDecoration(
                hintText: 'Type Something...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              maxLines: 3, // Limit the maximum number of lines
              onChanged: (value) {
                setState(() {
                  _typedText = value;
                });
              },
            )
                : TextButton(
              onPressed: _toggleEditing,
              child: Text(
                _typedText.isEmpty ? 'Type Something...' : _typedText,
                style: TextStyle(color: Colors.white70, fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
