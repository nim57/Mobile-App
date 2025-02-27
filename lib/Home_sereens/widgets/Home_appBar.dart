import 'package:echo_project_123/authentication_files/featuers/personalization/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../Utils/constants/colors.dart';
import '../../../Utils/device/device_utility.dart';
import '../../Utils/constants/image_Strings.dart';
import '../../Utils/helpers/helper_function.dart';
import 'shimmer.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.leadingOnPressed,
    required this.showSetting,
    this.leadigIcon,
    this.actions,
  });

  final VoidCallback? leadingOnPressed;
  final bool showSetting;
  final IconData? leadigIcon;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final dark = EHelperFunctions.isDarkMode(context);
    return Padding(
        padding: const EdgeInsets.only(left: 0, top: 5),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: showSetting
              ? IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Iconsax.setting_2,
                    color: dark ? EColor.white : EColor.dark,
                  ),
                )
              : leadingOnPressed != null
                  ? IconButton(
                      onPressed: leadingOnPressed,
                      icon: Icon(leadigIcon),
                    )
                  : null,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                  height: 25,
                  width: 90,
                  image: AssetImage(
                      dark ? EImages.darkAppLogo : EImages.LightAppLogo)),
              Obx(() {
                if (controller.profileLoading.value) {
                  return const EShimmerEffect(
                    width: 80,
                    height: 15,
                  );
                } else {
                  return Text(
                    'Hi, ${controller.user.value.fullname}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(color: const Color.fromARGB(255, 0, 0, 0)),
                  );
                }
              }),
            ],
          ),
          actions: actions,
        ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(EDeviceUtils.getAppBorHeight());
}
