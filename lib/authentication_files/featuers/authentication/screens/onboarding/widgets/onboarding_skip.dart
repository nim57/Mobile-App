import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import '../../../../../../Utils/constants/sizes.dart';
import '../../../../../../Utils/device/device_utility.dart';

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
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text('Skip'),
      ),
    );
  }
}
