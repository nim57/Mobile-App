import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Home_sereens/widgets/following_page/Views_count.dart';
import '../../Home_sereens/widgets/following_page/comment_box.dart';
import '../../Home_sereens/widgets/following_page/post_assets.dart';
import '../../Home_sereens/widgets/following_page/profile_information.dart';
import '../../Home_sereens/widgets/following_page/profile_pic.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../Utils/constants/sizes.dart';

class YourPost_Screen extends StatefulWidget {
  const YourPost_Screen({super.key});

  @override
  _YourPost_ScreenState createState() => _YourPost_ScreenState();
}

class _YourPost_ScreenState extends State<YourPost_Screen> {
  // List of reactions
  final List<String> reactions = ["👍", "❤️", "😂", "😮", "😢", "😡"];

  // Currently selected reaction, initialized to "👍"
  String selectedReaction = "❤️";

  // Whether to show all reactions
  bool showAllReactions = false;

  // Method to build the post
  Widget buildPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Post start
        const Row(
          children: [
            /// Profile_pic
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Profile_pic(image: EImages.userProfileImage1),
            ),
            SizedBox(width: ESizes.spaceBtwItems),

            /// Profile_information
            Post_infomation(),
          ],
        ),

        /// Post Assets
        const Post_Assets(),

        /// Reactor, comment, views icons
        Row(
          children: [
            // Reactor icon with popup
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Reactions popup
                  if (showAllReactions)
                    Positioned(
                      top: -60, // Positioning the popup above the reactor
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
                                    selectedReaction =
                                        reaction; // Update selected reaction
                                    showAllReactions =
                                        false; // Hide after selection
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
                  // Main reactor icon
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
                        selectedReaction, // Display the selected reaction
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Comment icon
            const Comment_box(),

            /// Views icon
            const Padding(
              padding: EdgeInsets.only(left: 70, top: 10),
              child: Icon(Iconsax.eye, size: 28),
            ),
            const Views_count(),

            /// Rating bars
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
          const Divider(), // Optional: To separate posts visually
          buildPost(),
          const Divider(), // Optional: To separate posts visually
          buildPost(),
          const Divider(), // Optional: To separate posts visually
          buildPost(),
          const Divider(), // Optional: To separate posts visually
          buildPost(),
        ],
      ),
    );
  }
}
