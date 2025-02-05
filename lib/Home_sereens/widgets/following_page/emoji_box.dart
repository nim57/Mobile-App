import 'package:flutter/material.dart';

class EmojiPickerDialog extends StatelessWidget {
  final List<String> emojis;

  const EmojiPickerDialog({super.key, required this.emojis});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pick an Emoji"),
      content: SingleChildScrollView(
        child: Wrap(
          children: emojis.map((emoji) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, emoji);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
