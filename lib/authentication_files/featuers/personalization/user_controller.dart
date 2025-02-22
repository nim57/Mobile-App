import 'package:echo_project_123/authentication_files/common/widgets/loaders/lodaders.dart';
import 'package:echo_project_123/authentication_files/data/repositories/user/user_model.dart';
import 'package:echo_project_123/authentication_files/data/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instonce => Get.find();

  final userRepository = Get.put(UserRepository());

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      if (userCredential != null) {
        // Conver Name to First and LAst name
        final nameParts =
            UserModel.nameParts(userCredential.user!.displayName ?? '');
        final username =
            UserModel.generateUsername(userCredential.user!.displayName ?? '');

        // Map data

        final user = UserModel(
          id: userCredential.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          username: username,
          email: userCredential.user!.email ?? '',
          phoneNumber: userCredential.user!.phoneNumber ?? '',
          profilePicture: userCredential.user!.photoURL ?? '',
        );

        // Save User Record
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      ELoaders.warningSnackBar(
          title: 'Data not saved',
          message:
              'Somthing went wrong while saving your information. You can re-save your data in your Profile.');
    }
  }
}
