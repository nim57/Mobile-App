import 'package:echo_project_123/authentication_files/common/widgets/loaders/lodaders.dart';
import 'package:echo_project_123/authentication_files/data/repositories/authentication/authentication_repository.dart';
import 'package:echo_project_123/authentication_files/data/repositories/user/user_model.dart';
import 'package:echo_project_123/authentication_files/data/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../User_profile/widgets/re_authenticate_user_lodin_form.dart';
import '../../../Utils/constants/image_Strings.dart';
import '../../../Utils/constants/sizes.dart';
import '../../../Utils/popups/fullscreen_loader.dart';
import '../authentication/controllers/signup/network_manager.dart';
import '../authentication/screens/login/login.dart';

class UserController extends GetxController {
  static UserController get instonce => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final VerifyEmail = TextEditingController();
  final VerifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// Fetch User Record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final userModel = await userRepository.fetchUserDetails();
      user.value = userModel; // Assuming user is an Rx<UserModel>
      print('User fetched successfully: ${userModel.fullname}');
    } catch (e) {
      user.value = UserModel.empty(); // ✅ Assign empty model on failure
      print(
          'Error fetching user: $e ==============================================================================');
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      // First Upload Rx User and then check if user data is already stored. if not store new data
      await fetchUserRecord();

      if (user.value.id.isEmpty) {
        if (userCredential != null) {
          // Conver Name to First and LAst name
          final nameParts =
              UserModel.nameParts(userCredential.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredential.user!.displayName ?? '');

          // Map data

          final user = UserModel(
            id: userCredential.user!.uid,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: username,
            email: userCredential.user!.email ?? '',
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            profilePicture: userCredential.user!.photoURL ?? '',
          );

          // Save User Record
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      ELoaders.warningSnackBar(
          title: 'Data not saved',
          message:
              'Somthing went wrong while saving your information. You can re-save your data in your Profile.');
    }
  }

  /// Delete Account Waring

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(ESizes.md),
        title: 'Delete Account',
        middleText:
            'Are you sure you want to delete your account premanetly? This action is not reversible and all of your data will be removeed premanetly.',
        confirm: ElevatedButton(
          onPressed: () async => deleteUserAccount(),
          child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: ESizes.lg),
              child: Text('Delete')),
        ),
        cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text('Cancel'),
        ));
  }

  /// Deleyte User Accout
  void deleteUserAccount() async {
    try {
      EFullScreenLoader.openLoadingDialog('Processing', EImages.E);

      /// First re-authenticate user
      final auth = AuthenticationRepository.instonce;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Re Verify Auth Email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          EFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          EFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ELoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// --Re_Authenticate before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      EFullScreenLoader.openLoadingDialog("Processing", EImages.E);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instonce
          .reAuthenticationWithEmailAndPassword(
              VerifyEmail.text.trim(), VerifyPassword.text.trim());
      await AuthenticationRepository.instonce.deleteAccount();
      EFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ELoaders.warningSnackBar(title: 'On Sanp!', message: e.toString());
    }
  }

  /// Uplpod Profile Image
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        // Upload Image
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        // Update user Image Record
        Map<String, dynamic> json = {'profilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();
        ELoaders.successSnackBor(
            title: 'Congratulation',
            message: 'Your Profile image has beed Update!');
      }
    } catch (e) {
      ELoaders.errorsnackBar(
          title: "OhSnap", message: 'something went worng: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}
