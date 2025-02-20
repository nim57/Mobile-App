import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../../Utils/constants/colors.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/device/device_utility.dart';
import '../../../../../../Utils/helpers/helper_function.dart';

class OnBoardingNavigation extends StatelessWidget {
  const OnBoardingNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = EHelperFunctions.isDarkMode(context);
    return Positioned(
        bottom: EDeviceUtils.getBottomNavigationBarHeight() + 25,
        left: ESizes.defaultSpace,
        child: SmoothPageIndicator(
          count: 3,
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          effect: ExpandingDotsEffect(
              activeDotColor: dark ? EColor.light : Colors.blue, dotHeight: 6),
        ));
  }
}
