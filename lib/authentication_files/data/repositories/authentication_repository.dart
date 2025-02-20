import 'package:echo_project_123/authentication_files/featuers/authentication/screens/login/login.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instonce => Get.find();

// Variables
  final deviceStorage = GetStorage();

  /// Called from main.dart on app lounch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to Show Relevant Screen
  screenRedirect() async {
    // Local Stroge
    if (kDebugMode) {
      print(
          '============================ Get Storage Auth Repo ===================');
      print(deviceStorage.read('IsFirstTime'));
    }

    deviceStorage.writeIfNull('IsFirstTime', true);
    deviceStorage.read('IsFirstTime') != true
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(const OnBoardingScreen());
  }

/* =============================Email & Password sign-in =======================*/

  /// [EmailAuthentication] - SignIn

  /// [EmailAuthentication] - REGISTER

  /// [ReAuthenticate] - ReAuthenticote User

  /// [EmailVerification] - MAIL VERIFICATION

  /// [EmailAuthenticotion] - FORGET PASSWORD

/*  ----------------------  Federated identity & social sign-in -----------------------*/

  /// [GoogleAuthenticotion] - GOOGLE

  ///[FacebookAuthentication] - FACEBOOK

/*  ----------------------  ./end Federated identity & social sign-in -----------------------*/

  /// [LogoutUser] - Valid for any authentication.

  /// DELETE USER - Remove user Auth and Firestore Account.
}
