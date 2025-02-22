import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/login/login_contorller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../../Utils/constants/colors.dart';
import '../../../../Utils/constants/image_Strings.dart';
import '../../../../Utils/constants/sizes.dart';

class social_buttons extends StatelessWidget {
  const social_buttons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginContorller());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: EColor.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            icon: const Image(
                width: ESizes.iconMd,
                height: ESizes.iconMd,
                image: AssetImage(EImages.google)),
          ),
        ),
        const SizedBox(
          width: ESizes.spaceBtwSections,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: EColor.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
                width: ESizes.iconMd,
                height: ESizes.iconMd,
                image: AssetImage(EImages.facebook)),
          ),
        ),
      ],
    );
  }
}
