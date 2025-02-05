import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../Utils/constants/colors.dart';
import '../../../Utils/device/device_utility.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../Utils/helpers/helper_function.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key, this.leadingOnPressed, required this.showSetting, this.leadigIcon, this.actions,});

  final VoidCallback? leadingOnPressed;
  final bool showSetting;
  final IconData? leadigIcon;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Padding(
        padding: const EdgeInsets.only(left: 120,top: 10),
        child:  AppBar(
          automaticallyImplyLeading: false,
          leading: showSetting
              ? IconButton(onPressed: () => Get.back(), icon: Icon(Iconsax.setting_2,color: dark ? EColor.white : EColor.dark,),)
              :leadingOnPressed != null? IconButton(onPressed: leadingOnPressed ,icon: Icon(leadigIcon),) :null,
          title: Image(
              height: 50,
              width: 160,
              image:AssetImage(dark ? EImages.darkAppLogo: EImages.LightAppLogo)),
          actions: actions,
        )
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(EDeviceUtils.getAppBorHeight());


}
