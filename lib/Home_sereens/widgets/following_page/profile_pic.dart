import 'package:flutter/material.dart';

import '../../../User_profile/widgets/i_circularImage.dart';
class Profile_pic extends StatelessWidget {
  const Profile_pic({
    super.key,
    required this.image,
    this.action,
  });

  final String image;
  final VoidCallback ? action;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: ECircularImage(
        image:image,
        width: 60,
        height: 60,
      ),
    );
  }
}
