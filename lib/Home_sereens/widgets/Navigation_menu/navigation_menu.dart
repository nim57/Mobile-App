import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../User_profile/screen/User_Screen.dart';
import '../../../Utils/constants/colors.dart';
import '../../../Utils/helpers/helper_function.dart';
import '../../../authentication_files/featuers/authentication/screens/login/login.dart';
import '../../screen/Add_new_post.dart';
import '../../screen/homescreen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController1());
    final darkmode = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 50,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          backgroundColor: darkmode ? EColor.black : Colors.white,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          indicatorColor: darkmode
              ? EColor.white.withOpacity(0.1)
              : EColor.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.message_add), label: 'New Post'),
            NavigationDestination(icon: Icon(Iconsax.message4), label: 'chat'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screen[controller.selectedIndex.value]),
    );
  }
}

class NavigationController1 extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screen = [
    const HomeScreen(),
    const AddNewPost(),
    const LoginScreen(),
    const SettingScreen(),
  ];
}
