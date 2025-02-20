import 'package:echo_project_123/Utils/constants/colors.dart';
import 'package:echo_project_123/Utils/helpers/helper_function.dart';
import 'package:echo_project_123/authentication_files/common/widgets/loaders/animation_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A utility class for managing a full-screen loading dialog.
class EFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context:
          Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible:
          false, // The dialog can't be dismissed by tapping outside it
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Container(
          color: EHelperFunctions.isDarkMode(Get.context!)
              ? EColor.dark
              : EColor.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250), // Adjust the spacing as needed
              EAnimationLoaderWidget(text: text, animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  /// stop  the currently open loding dialog.
  /// This method doesen't return anything.

  static stopLoading() {
    Navigator.of(Get.overlayContext!)
        .pop(); // colse the dialog using the Navigater
  }
}
