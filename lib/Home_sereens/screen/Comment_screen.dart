import 'package:echo_project_123/Home_sereens/screen/pending_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../User_profile/widgets/settings_menu_tile.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/constants/text_strings.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  double customerServiceRating = 0;
  double qualityOfServiceRating = 0;

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
                expands: false,
                decoration: const InputDecoration(
                  labelText: ETexts.Tags,
                  prefixIcon: Icon(Icons.tag_sharp),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),

              /// Item title
              TextFormField(
                expands: false,
                decoration: const InputDecoration(
                  labelText: ETexts.Item_title,
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),

              /// Comment
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Comment',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),

              /// Clear button
              Padding(
                padding: const EdgeInsets.only(left: 310),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    ETexts.clear,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),
              ESettingsMenuTile(icon: Iconsax.eye, title:'Visble or Not', subtitle: 'Your profile information see others users', trailing: Switch(value: true,onChanged: (value){},),),
              const SizedBox(height: ESizes.spaceBtwInputFields*2),

              /// Save button
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () => Get.to(() => const PendingMessage()),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
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

