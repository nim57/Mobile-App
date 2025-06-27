import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../textPost_backend/post_controller.dart';

class NewTextPost extends StatefulWidget {
  const NewTextPost({super.key});

  @override
  State<NewTextPost> createState() => _NewTextPostState();
}

class _NewTextPostState extends State<NewTextPost> {
  final PostController _postController = Get.put(PostController());
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  TextSelection _textSelection = const TextSelection.collapsed(offset: 0);
  
  Color _backgroundColor = Colors.blue;
  TextStyle _activeTextStyle = const TextStyle();
  String _typedText = '';
  
  bool _showColorPalette = false;
  bool _showTextStyles = false;
  bool _showDescription = false;
  
  final List<Color> _colorPalette = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.brown,
    Colors.deepPurple,
  ];

  // Text styles definitions
  final List<TextStyle> _textStyles = [
    const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal, fontSize: 32),
    const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 32),
    const TextStyle(fontFamily: 'Roboto', fontStyle: FontStyle.italic, fontSize: 32),
    const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 32),
    const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, fontSize: 32),
    const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 32),
    const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, fontSize: 32),
    const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w600, fontSize: 32),
    const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w400, letterSpacing: 1.2, fontSize: 32),
    const TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w700, letterSpacing: 1.2, fontSize: 32),
    const TextStyle(decoration: TextDecoration.underline, fontSize: 32),
    const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 32),
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateSelection);
    _textFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _textController.removeListener(_updateSelection);
    _textFocusNode.dispose();
    super.dispose();
  }

  void _updateSelection() {
    setState(() {
      _textSelection = _textController.selection;
      _typedText = _textController.text;
    });
  }

  void _handleFocusChange() {
    setState(() {
      if (!_textFocusNode.hasFocus) {
        _showColorPalette = false;
        _showTextStyles = false;
      }
    });
  }

  void _toggleTextStyles() {
    setState(() {
      _showTextStyles = !_showTextStyles;
      _showColorPalette = false;
      if (_showTextStyles) {
        _textFocusNode.unfocus();
      }
    });
  }

  void _toggleColorPalette() {
    setState(() {
      _showColorPalette = !_showColorPalette;
      _showTextStyles = false;
      if (_showColorPalette) {
        _textFocusNode.unfocus();
      }
    });
  }

  void _changeBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color;
      _showColorPalette = false;
    });
  }

  void _applyTextStyle(TextStyle style) {
    setState(() {
      _activeTextStyle = style;
      _showTextStyles = false;
    });
  }

  void _addEmoji(String emoji) {
    final int start = _textSelection.start;
    final int end = _textSelection.end;
    
    setState(() {
      _textController.value = TextEditingValue(
        text: _textController.text.replaceRange(start, end, emoji),
        selection: TextSelection.collapsed(offset: start + emoji.length),
      );
    });
  }

  double _getFontSize(String text) {
    if (text.isEmpty) return 40;
    final length = text.length;
    if (length < 10) return 48;
    if (length < 20) return 42;
    if (length < 30) return 36;
    if (length < 50) return 32;
    if (length < 70) return 28;
    if (length < 100) return 24;
    return 20;
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Select Emoji',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 6,
                  padding: const EdgeInsets.all(16),
                  children: [
                    '😀', '😂', '😍', '🥰', '😎', '😊',
                    '👍', '👏', '🙌', '❤️', '🔥', '🎉',
                    '🤔', '😭', '🥺', '😡', '🤯', '😴',
                    '🙏', '💯', '✨', '🎯', '💪', '👀',
                  ].map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        _addEmoji(emoji);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTextStylePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Select Text Style',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(16),
                  children: _textStyles.map((style) {
                    return GestureDetector(
                      onTap: () {
                        _applyTextStyle(style);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Aa',
                            style: style.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _uploadPost() {
    if (_textController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter some text');
      return;
    }
    
    _postController.uploadTextPost(
      textContent: _textController.text,
      backgroundColor: _backgroundColor,
      textStyle: _activeTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: () {
          if (!_textFocusNode.hasFocus) {
            _textFocusNode.requestFocus();
          } else {
            _textFocusNode.unfocus();
          }
        },
        child: Stack(
          children: [
            // Main content area
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.9,
                  maxHeight: screenHeight * 0.7,
                ),
                child: TextFormField(
                  controller: _textController,
                  focusNode: _textFocusNode,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _getFontSize(_typedText),
                    fontWeight: FontWeight.w600,
                  ).merge(_activeTextStyle),
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLines: null,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),

            // Top action bar
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _showTextStylePicker,
                          icon: const Icon(Iconsax.text, 
                              color: Colors.white, size: 30),
                          tooltip: 'Text Styles',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _toggleColorPalette,
                          icon: const Icon(Iconsax.paintbucket, 
                              color: Colors.white, size: 30),
                          tooltip: 'Background Color',
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _showEmojiPicker,
                          icon: const Icon(Iconsax.emoji_happy, 
                              color: Colors.white, size: 30),
                          tooltip: 'Add Emoji',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Description Input
            if (_showDescription)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 80,
                left: 24,
                right: 24,
                child: TextField(
                  controller: _postController.descriptionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Add a description...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

            // Bottom action bar
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        _showDescription ? Icons.cabin : Icons.description,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () => setState(() => _showDescription = !_showDescription),
                    ),
                    ElevatedButton(
                      onPressed: _uploadPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24, 
                          vertical: 12
                        ),
                      ),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: _backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Color palette overlay
            if (_showColorPalette)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _colorPalette.map((color) {
                        return GestureDetector(
                          onTap: () => _changeBackgroundColor(color),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: _backgroundColor == color
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}