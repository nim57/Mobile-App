import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../Utils/constants/colors.dart';
import '../../../Utils/constants/sizes.dart';
import '../../../Utils/device/device_utility.dart';
import '../../../Utils/helpers/helper_function.dart';


class EAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EAppBar({
    super.key,
    this.titlt,
    this.showBackArrow=false,
    this.leadigIcon,
    this.actions,
    this.leadingOnPressed});

  final Widget? titlt;
  final bool showBackArrow;
  final IconData? leadigIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Padding(
        padding:const EdgeInsets.symmetric(horizontal: ESizes.md),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: showBackArrow
              ? IconButton(onPressed: () => Get.back(), icon: Icon(Iconsax.arrow_left,color: dark ? EColor.white : EColor.dark,),)
              :leadingOnPressed != null? IconButton(onPressed: leadingOnPressed ,icon: Icon(leadigIcon),) :null,
          title:titlt,
          actions: actions,
        )
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(EDeviceUtils.getAppBorHeight());


}
