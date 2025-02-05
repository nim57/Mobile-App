import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/constants/sizes.dart';
import '../../Utils/constants/text_strings.dart';
import 'homescreen.dart';

class PendingMessage extends StatelessWidget {
  const PendingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 300),
        child: Center(
          child: Column(
            children: [
              const Center(
                child: CircularProgressIndicator(color: Colors.blue,),
              ),

              const SizedBox(height: ESizes.spaceBtwInputFields*4),

              /// Message
              const Text(
                "A response to your request will be ", style: TextStyle(color: Colors.black,fontSize: 18),),
              const Text(
                "given within 24 hours", style: TextStyle(color: Colors.black,fontSize: 18),),

              const SizedBox(height: ESizes.spaceBtwInputFields*2,),
              ///  save button
              GestureDetector(
                onTap: () => Get.to(() => const HomeScreen()),
                child: Container(
                    padding: const EdgeInsets.only(left:15,right: 15,top: 8,bottom: 8),
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: Colors.blueAccent
                    ),
                    child: const Text(ETexts.back,style: TextStyle(color:Colors.black,fontSize: 20))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
