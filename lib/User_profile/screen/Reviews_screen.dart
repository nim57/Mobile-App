import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:flutter_emoji/flutter_emoji.dart'; // For emoji support
import '../../Home_sereens/screen/New_replyORCommentScreen.dart';
import '../../Home_sereens/widgets/Comment&Review_widgets.dart';
import '../../Home_sereens/widgets/following_page/emoji_box.dart';
import '../../Home_sereens/widgets/following_page/profile_pic.dart';
import '../../User_profile/screen/User_Screen.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../common/widgets/appbar/appbar.dart';

class YourReviewScreen extends StatefulWidget {
  const YourReviewScreen({super.key});

  @override
  State<YourReviewScreen> createState() => _YourReviewScreenState();
}

class _YourReviewScreenState extends State<YourReviewScreen> {
  final EmojiParser emojiParser = EmojiParser();
  final List<String> emojis = [
    "😀",
    "😃",
    "😄",
    "😁",
    "😆",
    "😅",
    "😂",
    "🤣",
    "😊",
    "😇",
    "🙂",
    "🙃",
    "😉",
    "😌",
    "😍",
    "🥰",
    "😘",
    "😗",
    "😙",
    "😚"
  ];
  bool showAllReactions = false;
  final TextEditingController _replyController = TextEditingController();
  bool _showReplyBox = false;
  XFile? _selectedFile;
  String? _selectedEmoji;

  Future<void> _pickMedia(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _selectedFile = pickedFile;
    });
  }

  void _pickEmoji() async {
    final emoji = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return EmojiPickerDialog(emojis: emojis);
      },
    );
    if (emoji != null) {
      setState(() {
        _selectedEmoji = emoji;
      });
    }
  }

  void _showReplyBoxFunc() {
    setState(() {
      _showReplyBox = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const EAppBar(showBackArrow: true, titlt: Text('Comment & Review')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Image
                            const Profile_pic(image: EImages.userProfileImage1),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Comment Box
                                  const CommentreviewWidgets(),
                                  const SizedBox(height: 10),
                                  // RatingBar

                                  const SizedBox(height: 6),
                                  //  reply buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          // Reply Button
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: TextButton(
                                              onPressed: _showReplyBoxFunc,
                                              child: const Text(
                                                "Reply",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17),
                                              ),
                                            ),
                                          ),

                                          /// Like button
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 100),
                                            child: Stack(
                                              children: [
                                                IconButton(
                                                    onPressed: () => Get.to(() =>
                                                        const SettingScreen()),
                                                    icon: const Icon(
                                                        Iconsax.like_1)),
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '2',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .apply(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// DisLike Button
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Stack(
                                              children: [
                                                IconButton(
                                                    onPressed: () => Get.to(() =>
                                                        const SettingScreen()),
                                                    icon: const Icon(
                                                        Iconsax.dislike)),
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    width: 18,
                                                    height: 18,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '2',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .apply(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Positioned New Reply Button at the bottom center
          // Reply text box at the bottom
          if (_showReplyBox)
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _replyController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "Write a reply...",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15.0),
                          ),
                        ),
                      ),

                      /// photo Attach
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () => _pickMedia(ImageSource.gallery),
                      ),

                      /// emoji Attach
                      IconButton(
                        icon: const Icon(Icons.emoji_emotions),
                        onPressed: _pickEmoji,
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          print("Reply sent: ${_replyController.text}");
                          setState(() {
                            _replyController.clear();
                            _showReplyBox = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
