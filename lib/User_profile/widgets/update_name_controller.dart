import 'package:echo_project_123/User_profile/widgets/profile.dart';
import 'package:echo_project_123/Utils/constants/image_Strings.dart';
import 'package:echo_project_123/Utils/popups/fullscreen_loader.dart';
import 'package:echo_project_123/authentication_files/data/repositories/user/user_repository.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/signup/network_manager.dart';
import 'package:echo_project_123/authentication_files/featuers/personalization/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication_files/common/widgets/loaders/lodaders.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instonce;
  final userRepository = Get.put(UserRepository());
  final GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  /// init user data when Home Screen appears
  @override
  void onInit() {
    initializeName();
    super.onInit();
  }

  /// Fetch user record
  Future<void> initializeName() async {
    try {
      // Add null checks here to prevent null errors
      firstName.text = userController.user.value.firstName ?? '';
      lastName.text = userController.user.value.lastName ?? '';
      print("Initial First Name: ${firstName.text}");
      print("Initial Last Name: ${lastName.text}");
    } catch (e) {
      print("Error initializing name: $e");
      // Set default empty values if there's an error
      firstName.text = '';
      lastName.text = '';
    }
  }

  Future<void> updateUserName() async {
    try {
      // Start Loading
      EFullScreenLoader.openLoadingDialog(
          'We are updating your information...', EImages.E);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        ELoaders.errorsnackBar(
            title: 'No Internet Connection',
            message: 'Please check your internet connection and try again.');
        return;
      }

      // Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Capture input values
      String firstNameValue = firstName.text.trim();
      String lastNameValue = lastName.text.trim();
      print("Updated First Name: $firstNameValue");
      print("Updated Last Name: $lastNameValue");

      // Update user's first & last name in Firebase Firestore
      Map<String, dynamic> name = {
        'FirstName': firstNameValue,
        'LastName': lastNameValue
      };
      await userRepository.updateSingleField(name);

      // Update the Rx User value
      userController.user.value.firstName = firstNameValue;
      userController.user.value.lastName = lastNameValue;

      // Remove Loader
      EFullScreenLoader.stopLoading();

      // Show Success Message
      ELoaders.successSnackBor(
          title: 'Congratulations', message: 'Your name has been updated.');

      // Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      EFullScreenLoader.stopLoading();
      print("Error: $e");
      ELoaders.errorsnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
