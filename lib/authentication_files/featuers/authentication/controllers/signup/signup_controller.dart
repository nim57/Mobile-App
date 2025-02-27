import 'package:echo_project_123/Utils/constants/image_Strings.dart';
import 'package:echo_project_123/Utils/popups/fullscreen_loader.dart';
import 'package:echo_project_123/authentication_files/common/widgets/loaders/lodaders.dart';
import 'package:echo_project_123/authentication_files/data/repositories/authentication/authentication_repository.dart';
import 'package:echo_project_123/authentication_files/data/repositories/user/user_model.dart';
import 'package:echo_project_123/authentication_files/data/repositories/user/user_repository.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/signup/network_manager.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/signup/veryfy_email.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instonce => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormkey = GlobalKey<FormState>();

  /// -- SIGNUP
  void signup() async {
    try {
      // Start Loading
      EFullScreenLoader.openLoadingDialog(
          'We are processing yout information....', EImages.onboardingImage1);
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormkey.currentState!.validate()) {
        // Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }
      // Privacy Policy Check
      if (!privacyPolicy.value) {
        ELoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message: 'Please accept the privacy policy to continue');
        return;
      }

      // Register user in the Firebase Authentication & Save user data in the Firebase

      final UserCredential = await AuthenticationRepository.instonce
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save Authenticated user data in the Firebase Firestore

      final newUser = UserModel(
        id: UserCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      // Show Success Message
      ELoaders.successSnackBor(
          title: 'Congratulations',
          message: 'Your account has been created! Veryfy email to continue.');

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(
            email: email.text.trim(),
          ));
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      ELoaders.errorsnackBar(title: 'oh Snap!', message: e.toString());
    }
  }
}
