import 'package:echo_project_123/Home_sereens/FInder_screens/Finder_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../User_profile/screen/User_Screen.dart';
import '../../../Utils/constants/colors.dart';
import '../../../Utils/helpers/helper_function.dart';
import '../../../qr_files/qr_scan_page.dart';
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
            NavigationDestination(icon: Icon(Iconsax.scan), label: 'Scanner'),
            NavigationDestination(icon: Icon(Iconsax.map), label: 'Finder'),
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
    const QRScanPage(),
     MapScreen(),
    const SettingScreen(),
  ];
}
