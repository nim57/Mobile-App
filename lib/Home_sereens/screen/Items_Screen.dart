import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for navigation

import '../../Utils/constants/image_Strings.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../widgets/New_post/Item_tile2.dart';
import 'Item_Details.dart';

class Item_Screen extends StatelessWidget {
  const Item_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the number of columns
    const int columns = 2;

    // Sample data for demonstration purposes
    final List<String> logos = [
      EImages.boc,
      EImages.boc, // Add more image strings or logos as needed
      EImages.boc,
      EImages.boc,
      EImages.boc,
      EImages.boc,
      EImages.boc,
      EImages.boc,
      EImages.boc,
    ];

    // Define actions
    final List<VoidCallback> actions = [
          () => Get.to(() =>  const ItemDetailScreen()), // Action for the first item
          () => print('Action 2'),  // Action for the second item
          () => print('Action 3'),  // Continue adding actions as needed
      // Add more actions matching the number of logos
    ];

    return Scaffold(
      appBar: const EAppBar(titlt: Text('Item Screen',),showBackArrow: true,),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1, // Adjust this ratio to customize the tile size
          ),
          itemCount: logos.length,
          itemBuilder: (context, index) {
            return Item_tile2(
              logo: logos[index],
              action: actions.length > index ? actions[index] : null,
            );
          },
        ),
      ),
    );
  }
}
