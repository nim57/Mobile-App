import 'package:echo_project_123/Home_sereens/widgets/widgets_home/ratingBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/constants/sizes.dart';
import '../screen/comment_box.dart';

class CommentreviewWidgets extends StatelessWidget {
  const CommentreviewWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const CommentBox());
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.2), // Shadow color with opacity
                spreadRadius: 2, // Spread radius
                blurRadius: 8, // Blur radius
                offset: const Offset(0, 4), // Shadow offset (horizontal, vertical)
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "@Nimeshsandaruwan",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // Date
                  Text(
                    "2d",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              Text(
                '#Boc',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              Text(
                "CraditCard good Services",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ESizes.spaceBtwItems),

              /// RatingBar
              RatingBarWidget(
                customerServiceRating: 57, // Replace with actual values
                qualityOfServiceRating: 37, // Replace with actual values
              ),
              SizedBox(height: ESizes.spaceBtwItems),
              Text(
                'The bank has a network of 651 branches, 715 automated teller machines (ATMs), 159 CDM, 582 CRM network, and 15 regional loan centres within the country. It also has an around-the-clock call centre and an around the clock branch at its Colombo office.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
