import 'package:echo_project_123/Utils/constants/image_Strings.dart';
import 'package:echo_project_123/Utils/popups/fullscreen_loader.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/forget_password/reset_passwprd.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/signup/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/loaders/lodaders.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instonce => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reser Password EMail
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Processing your request....', EImages.userProfileImage1);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // SEND EMAIL TO RESET PASSWORD
      await AuthenticationRepository.instonce
          .sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      EFullScreenLoader.stopLoading();

      // Show Success Message
      ELoaders.successSnackBor(
          title: 'Email Sent',
          message:
              'An email has been sent to ${email.text.trim()} with instructions to reset your password');

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();
      ELoaders.errorsnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Processing your request....', EImages.userProfileImage1);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // SEND EMAIL TO RESET PASSWORD
      await AuthenticationRepository.instonce.sendPasswordResetEmail(email);

      // Remove Loader
      EFullScreenLoader.stopLoading();

      // Show Success Message
      ELoaders.successSnackBor(
          title: 'Email Sent',
          message: 'Email Link Send to Resend Your Password');
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();
      ELoaders.errorsnackBar(title: 'Oh Snap', message: 'An error occured');
    }
  }
}
