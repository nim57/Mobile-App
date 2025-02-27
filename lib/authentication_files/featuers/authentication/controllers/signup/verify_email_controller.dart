import 'dart:async';

import 'package:echo_project_123/Utils/constants/text_strings.dart';
import 'package:echo_project_123/authentication_files/common/widgets/loaders/lodaders.dart';
import 'package:echo_project_123/authentication_files/common/widgets/success_screen/sussess_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../Utils/constants/image_Strings.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instonce => Get.find();

  /// Variables
  final email = ''.obs;

  /// Send Email Wheneever Verify Screen oppears & Set Time for outo redirect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instonce.sendEmailVerification();
      ELoaders.successSnackBor(
          title: 'Oh Snap!',
          message: 'Please check your inbox and verify your email.');
    } catch (e) {
      ELoaders.errorsnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// Timer to automaticaly redirect to Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => SuccessScreen(
              image: EImages.succes,
              title: ETexts.accountCreatedTitle,
              subTitle: ETexts.yourAccountCreatedSubTitle,
              onPressed: () =>
                  AuthenticationRepository.instonce.screenRedirect()),
        );
      }
    });
  }

  /// Manual Check of Email Verified

  checkEmailVerifycationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
            image: EImages.succes,
            title: ETexts.accountCreatedTitle,
            subTitle: ETexts.yourAccountCreatedSubTitle,
            onPressed: () =>
                AuthenticationRepository.instonce.screenRedirect()),
      );
    }
  }
}
