import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../User_profile/screen/User_Screen.dart';
import '../../Utils/constants/colors.dart';
import '../../Utils/helpers/helper_function.dart';

class ESettingIcon extends StatelessWidget {
  const  ESettingIcon({
    super.key,
    required this.onPressed,
    this.iconColor ,
    this.counterTextColor,
    this.counterBgColor,
  });
  final VoidCallback onPressed;
  final Color? iconColor, counterTextColor,counterBgColor;


  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Stack(children:[
      IconButton(onPressed: () => Get.to(() => const SettingScreen()), icon: Icon(Iconsax.setting_2,color:  iconColor)),
      Positioned(
        right:0,
        child: Container(
          width: 18,
          height: 18,
          decoration:  BoxDecoration(
            color: counterBgColor ?? (dark ? EColor.white : EColor.black),
            borderRadius: BorderRadius.circular(100),),
          child: Center(
            child: Text('2',style: Theme.of(context).textTheme.labelLarge!.apply(color: counterTextColor,fontSizeFactor: 0.8),),),
        ),
      ),
    ],
    );
  }
}