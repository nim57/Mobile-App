import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../Utils/constants/colors.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/device/device_utility.dart';
import '../../../../../../Utils/helpers/helper_function.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Positioned(
        right: ESizes.defaultSpace,
        bottom: EDeviceUtils.getBottomNavigationBarHeight(),
        child: ElevatedButton(
          onPressed: () => OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: dark ? EColor.primaryColor : Colors.blueAccent),
          child: const Icon(Iconsax.arrow_right_3),
        ));
  }
}
