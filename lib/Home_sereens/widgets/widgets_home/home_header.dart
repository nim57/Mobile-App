import 'package:flutter/material.dart';
import '../../../../../Utils/constants/image_Strings.dart';

class Header_home extends StatelessWidget {
  const Header_home({
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
          children: [
            Image(
                height: 80,
                width: 220,
                image:AssetImage(dark ? EImages.text_logo: EImages.text_logo)),
          ],
        ),

      ],
    );
  }
}