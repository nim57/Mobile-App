import 'package:echo_project_123/Utils/popups/fullscreen_loader.dart';
import 'package:echo_project_123/authentication_files/common/widgets/loaders/lodaders.dart';
import 'package:echo_project_123/authentication_files/data/repositories/authentication/authentication_repository.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/signup/network_manager.dart';
import 'package:echo_project_123/authentication_files/featuers/personalization/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../Utils/constants/image_Strings.dart';

class LoginContorller extends GetxController {
  /// Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorrage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  // @override
  // void onInit() {
  //   email.text = localStorrage.read('REMENBER_ME_EMAIL');
  //   password.text = localStorrage.read('_REMEMBER_ME_Password');
  //   super.onInit();
  // }

  /// -- Email and Password Signin
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loding
      EFullScreenLoader.openLoadingDialog(
          'Loging you in...', EImages.onboardingImage1);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation

      if (!loginFormkey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // save Data if remember me is checked
      if (rememberMe.value) {
        localStorrage.write('REMENBER_ME_EMAIL', email.text.trim());
        localStorrage.write('_REMEMBER_ME_Password', password.text.trim());
      }

      // Login user using Email and password authentication
      final userCredential = await AuthenticationRepository.instonce
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove Loader
      EFullScreenLoader.stopLoading();

      //Redirect
      AuthenticationRepository.instonce.screenRedirect();
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ELoaders.errorsnackBar(title: 'oh Snap', message: e.toString());
    }
  }

  /// -- Google Signin Authentication
  Future<void> googleSignIn() async {
    try {
      // Start Loding
      EFullScreenLoader.openLoadingDialog('Loging you in...', EImages.user1);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Google Authentication
      final userCredential =
          await AuthenticationRepository.instonce.signInWithGoogle();

      /// Save User Record
      await userController.saveUserRecord(userCredential);

      // Remove Loader
      EFullScreenLoader.stopLoading();

      //Redirect
      AuthenticationRepository.instonce.screenRedirect();
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();
      ELoaders.errorsnackBar(title: 'oh Snap', message: e.toString());
    }
  }
}
