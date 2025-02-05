import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/constants/colors.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../widgets/widgets_home/ratingBarWidget.dart';
import 'Comment&ReviewScreen.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(titlt: Text('Item Details'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                EImages.boc, // Replace with your image URL
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Row(
                    children: [
                      /// Informations
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BANK OF CEYLON',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          /// # Tags
                          Row(
                            children: [
                              Text(
                                '#Boc',
                                style: TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '#BANKOFCEYLON',
                                style: TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '#Boc',
                                style: TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Presentage Box
                      Padding(
                        padding: const EdgeInsets.only( left: 15), // Adjust the padding as needed
                        child: GestureDetector(
                          onTap:(){},
                          child: Container(
                            padding: const EdgeInsets.only(top:15,bottom: 15,left: 8,right: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(13)),
                              color: EColor.paccent,
                            ),
                            child: const Column(
                              children: [
                                Text("48%"),
                                Text("Useer Avg")
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  /// RatingBar
                  const RatingBarWidget(
                    customerServiceRating: 57,  // Replace with actual values
                    qualityOfServiceRating: 37, // Replace with actual values
                  ),

                  const SizedBox(height: 25),
                  /// Information
                  const Text(
                    'The bank has a network of 651 branches, 715 automated teller machines (ATMs), 159 CDM, 582 CRM network, and 15 regional loan centres within the country. It also has an around-the-clock call centre and an around the clock branch at its Colombo office.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  /// Email
                  const Row(
                    children: [
                      Text('Email Address : ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('BankOfCeylon123@Gmail.com', style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // webSite
                  const Row(
                    children: [
                      Text('Web Site : ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('WWW.BankOfCeylon.Com', style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Contact numbers
                  const Row(
                    children: [
                      Text('Contact No : ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('011 2345674', style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  /// Button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: ()=> Get.to(()=> const CommentReviewScreen()),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: const Text('View Comments'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


