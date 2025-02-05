import 'package:flutter/material.dart';

import '../../../Utils/constants/image_Strings.dart';

class Post_Assets extends StatelessWidget {
  const Post_Assets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45, top: 10),
      child: Container(
        width: 320,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: const Image(fit: BoxFit.fill, image: AssetImage(EImages.Ads1)),
        ),
      ),
    );
  }
}
