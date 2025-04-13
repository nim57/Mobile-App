// comment_tile.dart
import 'package:flutter/material.dart';
import 'comment_controller.dart';
import 'comment_model.dart';

class CommentTile extends StatelessWidget {
  final CommentModel comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _userHeader(context),
        const SizedBox(height: 16),
        Text(comment.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(comment.text),
        const SizedBox(height: 12),
        _tags(),
        _actionButtons(),
      ],
    );
  }

 Widget _userHeader(BuildContext context) => Row(
  children: [
    CircleAvatar(
      backgroundImage: comment.userProfile.isNotEmpty
          ? NetworkImage(comment.userProfile)
          : const AssetImage('Assets/App_Assets/authentication_assets/user1.png') as ImageProvider,
    ),
    const SizedBox(width: 12),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(comment.username),
        Text(
          CommentController.instance.getTimeAgo(comment.timestamp),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  ],
);

  Widget _tags() => Wrap(
        spacing: 8,
        children: comment.tags
            .map((tag) => Chip(
                  label: Text('#$tag'),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ))
            .toList(),
      );

  Widget _actionButtons() => Row(
        children: [
          IconButton(icon: const Icon(Icons.thumb_up), onPressed: () {}),
          IconButton(icon: const Icon(Icons.thumb_down), onPressed: () {}),
          TextButton(
            onPressed: () {},
            child: const Text("Reply"),
          ),
        ],
      );
}