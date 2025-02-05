import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/constants/sizes.dart';
import '../../screen/comment_box.dart';

class Comment_Post extends StatelessWidget {
  const Comment_Post({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const CommentBox());
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
            color: Colors.grey[200],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@Nimeshsandaruwan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ESizes.spaceBtwItems / 2),
              Text(
                "Ashok Leyland 13.5M Intercity \nbus Chassis Specifications ; GVW /\nGCW (Kgs), 18500 kg ; Overall Length \n(mm), 13265 ; Wheelbase (mm), 7000 \nmm ; No Of Seats, D+58 ...",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
