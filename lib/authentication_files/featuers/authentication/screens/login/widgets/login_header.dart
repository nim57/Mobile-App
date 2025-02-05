import 'package:flutter/material.dart';
import '../../../../../../Utils/constants/image_Strings.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/constants/text_strings.dart';


class Header_login extends StatelessWidget {
  const Header_login({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
            height: 80,
            width: 200,
            image:AssetImage(dark ? EImages.darkAppLogo: EImages.LightAppLogo)),
        const SizedBox(height: ESizes.sm,),
        Text(ETexts.loginTitle,style: Theme.of(context).textTheme.headlineMedium,),
        const SizedBox(height: ESizes.sm,),
        Text(ETexts.loginSubtitle,style: Theme.of(context).textTheme.bodyMedium,),
      ],
    );
  }
}