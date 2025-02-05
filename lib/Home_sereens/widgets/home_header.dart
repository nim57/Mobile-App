import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../Utils/constants/image_Strings.dart';


class Home_header extends StatelessWidget {
  const Home_header({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Image(
                  height: 50,
                  width: 160,
                  image:AssetImage(dark ? EImages.darkAppLogo: EImages.LightAppLogo)),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Iconsax.setting_2)),
          ],
        ),
      ],
    );
  }
}