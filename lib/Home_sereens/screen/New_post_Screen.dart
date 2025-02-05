import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../Utils/constants/image_Strings.dart';
import '../widgets/New_post/item_tile.dart';
import 'Add_Mising_item.dart';
import 'Items_Screen.dart';

class NewPost_Screen extends StatelessWidget {
  const NewPost_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Black background to match the card's design
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bank Icon and Text Card
              Item_tile(image: EImages.bank, name: 'Bank',action: () => Get.to(() => const Item_Screen()),),
              const SizedBox(height: 20),
              const Item_tile(image: EImages.cloth, name: 'Clothing Shop',),
              const SizedBox(height: 20),
              const Item_tile(image: EImages.insurance, name: 'Insurance',),
              const SizedBox(height: 20),
              const Item_tile(image: EImages.food, name: 'Food &  Hottles',),
              const SizedBox(height: 20),
              const Item_tile(image: EImages.supermarket, name: 'Supermarket',),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only( bottom: 70,right: 20), // Adjust the padding as needed
                  child: GestureDetector(
                    onTap:() => Get.to(() => const Add_Mising_item()),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        color: Colors.blue,
                      ),
                      child: const Icon(Iconsax.add, size: 30, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

