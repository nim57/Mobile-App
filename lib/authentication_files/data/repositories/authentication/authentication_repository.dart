import 'dart:io';

import 'package:echo_project_123/Home_sereens/widgets/Navigation_menu/navigation_menu.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/login/login.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/onboarding/onboarding.dart';
import 'package:echo_project_123/authentication_files/featuers/authentication/screens/signup/veryfy_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instonce => Get.find();

// Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Called from main.dart on app lounch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to Show Relevant Screen
  screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(
            () => VerifyEmailScreen(email: user.email ?? 'Email not found'));
      }
    } else {
      // Local Stroge
      deviceStorage.writeIfNull('IsFirstTime', true);

      // Check if user is first time or not
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(const OnBoardingScreen());
    }
  }
/* =============================Email & Password sign-in =======================*/

  /// [EmailAuthentication] - LOGIN

  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FormatException catch (_) {
      throw FormatException('Invalid format');
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } catch (e) {
      throw 'Something went wrong. Please try again later.';
    }
  }

  /// [EmailAuthentication] - REGISTER

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FormatException catch (_) {
      throw FormatException('Invalid format');
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } catch (e) {
      throw 'Something went wrong. Please try again later.';
    }
  }

  /// [ReAuthenticate] - ReAuthenticote User

  /// [EmailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FormatException catch (_) {
      throw FormatException('Invalid format');
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } catch (e) {
      throw 'Something went wrong. Please try again later.';
    }
  }

  /// [EmailAuthenticotion] - FORGET PASSWORD

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FormatException catch (_) {
      throw FormatException('Invalid format');
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } catch (e) {
      throw 'Something went wrong. Please try again later.';
    }
  }

/*  ----------------------  Federated identity & social sign-in -----------------------*/

  /// [GoogleAuthenticotion] - GOOGLE

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FormatException catch (_) {
      throw FormatException('Invalid format');
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } catch (e) {
      if (kDebugMode) print('Something went wrong.: $e.');
      throw 'Something went wrong. Please try again later.';
    }
  }

  ///[FacebookAuthentication] - FACEBOOK

/*  ----------------------  ./end Federated identity & social sign-in -----------------------*/

  /// [LogoutUser] - Valid for any authentication.
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FirebaseException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } on FormatException catch (_) {
      throw FormatException('Invalid format');
    } on PlatformException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } catch (e) {
      throw 'Something went wrong. Please try again later.';
    }
  }

  /// DELETE USER - Remove user Auth and Firestore Account.
}
