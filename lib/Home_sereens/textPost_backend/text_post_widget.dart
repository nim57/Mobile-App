import 'package:flutter/material.dart';

import 'post_model.dart';

class TextPostWidget extends StatelessWidget {
  final PostModel post;

  const TextPostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
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

  // Simple text style parser (in real app, use a more robust solution)
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
}