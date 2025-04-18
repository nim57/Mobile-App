// screens/comment_screen.dart
import 'package:echo_project_123/Home_sereens/screen/pending_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../authentication_files/featuers/personalization/user_controller.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/constants/text_strings.dart';
import '../comment_backend/comment_controller.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.itemId});

  final String itemId;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CommentController _commentController = Get.put(CommentController());
  final UserController _userController = Get.put(UserController());
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _clearForm() {
    _tagsController.clear();
    _titleController.clear();
    _commentTextController.clear();
    _commentController.isVisible.value = true;
  }

  void _submitComment() {
    _commentController.submitComment(
      itemId: widget.itemId,
      tags: _tagsController.text.split(',').map((e) => e.trim()).toList(),
      title: _titleController.text,
      text: _commentTextController.text,
      userId: _userController.user.value.id,
      username: _userController.user.value.username,
      userProfile: _userController.user.value.profilePicture,
    );
    _clearForm();
    Get.to(() => const PendingMessage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Tags
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: ETexts.Tags,
                  prefixIcon: Icon(Icons.tag_sharp),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),

              /// Item title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: ETexts.Item_title,
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),

              /// Comment (Multi-line with scroll)
              SizedBox(
                height: 150, // Fixed height for 4 lines
                child: TextFormField(
                  controller: _commentTextController,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Comment',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),

              /// Visibility Switch with Obx
              Obx(
                () => SwitchListTile(
                  title: const Text('Visible to Public'),
                  value: _commentController.isVisible.value,
                  onChanged: (value) =>
                      _commentController.isVisible.value = value,
                ),
              ),

              const SizedBox(height: ESizes.spaceBtwInputFields * 2),

              /// Save button
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: _submitComment,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 8, bottom: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      color: Colors.blueAccent,
                    ),
                    child: const Text(
                      ETexts.save_button,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
