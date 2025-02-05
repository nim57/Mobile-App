import 'package:flutter/material.dart';

import '../../../Utils/constants/colors.dart';
import '../../../Utils/device/device_utility.dart';
import '../../../Utils/helpers/helper_function.dart';

class BTabBar extends StatelessWidget  implements PreferredSizeWidget{
  const BTabBar({super.key, required this.tabs});

  final List<Widget> tabs;
  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? EColor.black : EColor.white,
      child: TabBar(
        tabs:tabs,
        isScrollable: true,
        indicatorColor: EColor.primaryColor,
        labelColor: dark ? EColor.white : EColor.primaryColor,
        unselectedLabelColor: EColor.darkGrey,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(EDeviceUtils.getAppBorHeight());
}
