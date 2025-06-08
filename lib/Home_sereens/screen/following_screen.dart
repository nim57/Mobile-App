import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../Utils/constants/sizes.dart';
import '../widgets/following_page/Views_count.dart';
import '../widgets/following_page/comment_box.dart';
import '../widgets/following_page/post_assets.dart';
import '../widgets/following_page/profile_information.dart';
import '../widgets/following_page/profile_pic.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<String> reactions = ["👍", "❤️", "😂", "😮", "😢", "😡"];
  String selectedReaction = "❤️";
  bool showAllReactions = false;

  Widget buildPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Profile_pic(image: EImages.userProfileImage1),
            ),
            SizedBox(width: ESizes.spaceBtwItems),
            Post_infomation(),
          ],
        ),
        const Post_Assets(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (showAllReactions)
                    Positioned(
                      top: -60,
                      left: 0,
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: reactions.map((reaction) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedReaction = reaction;
                                    showAllReactions = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    reaction,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAllReactions = !showAllReactions;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        selectedReaction,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Comment_box(),
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 10),
              child: Icon(Iconsax.eye, size: 28),
            ),
            const Views_count(),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildPost(),
          const Divider(),
          buildPost(),
          const Divider(),
          buildPost(),
          const Divider(),
          buildPost(),
          const Divider(),
          buildPost(),
        ],
      ),
    );
  }
}