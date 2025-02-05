import 'package:echo_project_123/Home_sereens/screen/pending_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/constants/colors.dart';
import '../../Utils/constants/sizes.dart';
import '../../Utils/constants/text_strings.dart';
import '../../common/widgets/appbar/appbar.dart';

class Add_Mising_item extends StatefulWidget {
  const Add_Mising_item({super.key});

  @override
  State<Add_Mising_item> createState() => _Add_Mising_itemState();
}

class _Add_Mising_itemState extends State<Add_Mising_item> {

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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(titlt: Text("Add Mising Item"),showBackArrow: true, ),
      body:Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 30,right: 30,top: 20),
          child: Column(
            children: [

              /// Item name
              TextFormField(
                expands: false,
                decoration: const InputDecoration(labelText: ETexts.Name,prefixIcon: Icon(Iconsax.user)),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields,),

              /// Item title
              TextFormField(
                expands: false,
                decoration: const InputDecoration(labelText: ETexts.Item_title,prefixIcon: Icon(Iconsax.user)),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields,),

              /// website
              TextFormField(
                expands: false,
                decoration: const InputDecoration(labelText: ETexts.Website,prefixIcon: Icon(Icons.web)),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields,),

              /// Email
              TextFormField(
                expands: false,
                decoration: const InputDecoration(labelText: ETexts.email,prefixIcon: Icon(Iconsax.message)),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields,),

              /// Tags
              TextFormField(
                expands: false,
                decoration: const InputDecoration(labelText: ETexts.Tags,prefixIcon: Icon(Icons.tag_sharp)),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields,),

              /// Post description
              TextFormField(
                expands: false,
                decoration: const InputDecoration(labelText: ETexts.Post_description,prefixIcon: Icon(Icons.pending)),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields,),
              
              /// Add Photo
              Row(
                children: [
                  const Text(ETexts.Featured,style: TextStyle(color:Colors.black,fontSize: 15)),
                  const SizedBox(width: ESizes.spaceBtwInputFields,),
                  GestureDetector(
                    onTap:() => _pickMedia(ImageSource.gallery),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: EColor.paccent
                      ),
                      child: const Text(ETexts.Featured1,style: TextStyle(color:Colors.black,))
                    ),
                  ),
                ],
              ),
              
              ///clear button
              Padding(
                padding: const EdgeInsets.only(left: 270),
                child: TextButton(
                    onPressed: (){},
                    child: const Text(ETexts.clear,style: TextStyle(fontSize: 17),)),
              ),

              ///  save button
              GestureDetector(
                onTap: () => Get.to(() => const PendingMessage()),
                child: Container(
                    padding: const EdgeInsets.only(left:15,right: 15,top: 8,bottom: 8),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: Colors.blueAccent
                    ),
                    child: const Text(ETexts.save_button,style: TextStyle(color:Colors.black,fontSize: 20))
                ),
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}
