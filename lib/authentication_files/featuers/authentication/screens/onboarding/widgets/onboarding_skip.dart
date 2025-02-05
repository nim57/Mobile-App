import 'package:flutter/material.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/device/device_utility.dart';
import '../../../controllers.onbparding/onboarding_controller.dart';

class OnBoardinSkip extends StatelessWidget {
  const OnBoardinSkip({
    super.key,
  });
  /// Skip Button
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: EDeviceUtils.getAppBorHeight(),
      right: ESizes.defaultSpace,
      child: TextButton(onPressed: () => OnBoardingController.instance.skipPage(), child: const Text('Skip'),),);
  }
}