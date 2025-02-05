import 'package:flutter/material.dart';

import '../../../Utils/constants/sizes.dart';

class Post_infomation extends StatelessWidget {
  const Post_infomation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "@NimeshSandaruwan",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: ESizes.spaceBtwItems),
            const Text(". 2d ", style: TextStyle(color: Colors.black)),
          ],
        ),
        const Row(
          children: [
            Text("# ABCD ", style: TextStyle(color: Colors.blue)),
            SizedBox(width: ESizes.spaceBtwItems),
            Text("# 1234 ", style: TextStyle(color: Colors.blue)),
          ],
        ),
        const Text(
          "Srilankan most popular shop in Srilanka",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
      ],
    );
  }
}
