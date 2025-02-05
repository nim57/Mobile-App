import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../screen/comment_box.dart';

class Comment_box extends StatelessWidget {
  const Comment_box({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(left: 90, top: 10),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const CommentBox());
        },
        child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Icon(Iconsax.message_2,size: 28,)
        ),
      ),
    );
  }
}