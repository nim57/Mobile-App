import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:flutter_emoji/flutter_emoji.dart'; // For emoji support
import '../../Utils/constants/image_Strings.dart';
import '../../Utils/constants/sizes.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../widgets/following_page/Comment_post.dart';
import '../widgets/following_page/emoji_box.dart';
import '../widgets/following_page/profile_pic.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({super.key});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  // List of reactions
  final List<String> reactions = ["👍", "❤️", "😂", "😮", "😢", "😡"];

  // Emoji parser
  final EmojiParser emojiParser = EmojiParser();

  // Predefined list of emojis
  final List<String> emojis = [
    "😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇",
    "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚"
  ];

  // Currently selected reaction, initialized to "❤️"
  String selectedReaction = "❤️";

  // Whether to show all reactions
  bool showAllReactions = false;

  // Controller for reply text field
  final TextEditingController _replyController = TextEditingController();

  // To control the visibility of the reply text box
  bool _showReplyBox = false;

  // To store the selected image or GIF
  XFile? _selectedFile;

  // To store the picked emoji
  String? _selectedEmoji;

  // Function to pick image or GIF
  Future<void> _pickMedia(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _selectedFile = pickedFile;
    });
  }

  // Function to pick emoji
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

  // Function to show the reply box
  void _showReplyBoxFunc() {
    setState(() {
      _showReplyBox = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(showBackArrow: true, titlt: Text('Comment Box ')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Profile Image
                          const Padding(
                            padding: EdgeInsets.only(bottom: 90, left: 8),
                            child: Profile_pic(image: EImages.userProfileImage1,),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Comment Box
                              const Comment_Post(),
                              // Date, reply, react buttons
                              const SizedBox(height: ESizes.spaceBtwItems / 2),
                              Row(
                                children: [
                                  // Date
                                  const Text(
                                    " 2d",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // React Button
                                  Padding(
                                    padding: const EdgeInsets.only(left: 60, top: 0),
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
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                                          selectedReaction = reaction; // Update selected reaction
                                                          showAllReactions = false; // Hide after selection
                                                        });
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                            child: const Text(
                                              "Like", // Display the selected reaction
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Reply
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: TextButton(
                                      onPressed: _showReplyBoxFunc,
                                      child: const Text(
                                        " Reply",
                                        style: TextStyle(color: Colors.black, fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Positioned New Reply Button at the bottom center
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only( bottom: 70,right: 20), // Adjust the padding as needed
              child: GestureDetector(
                onTap:  _showReplyBoxFunc,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    color: Colors.blue,
                  ),
                  child: const Icon(Iconsax.add, size: 30, color: Colors.black),
                ),
              ),
            ),
          ),

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
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
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
