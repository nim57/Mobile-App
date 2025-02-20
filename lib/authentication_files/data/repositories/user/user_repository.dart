import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'user_model.dart';

class EFirebaseException implements Exception {
  final String code;
  EFirebaseException(this.code);

  String get message => 'Firebase Exception: $code';
}

class EFormatException implements Exception {
  const EFormatException();

  String get message => 'Format Exception';
}

class EPlatformException implements Exception {
  final String code;
  EPlatformException(this.code);

  String get message => 'Platform Exception: $code';
}

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw EFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const EFormatException();
    } on PlatformException catch (e) {
      throw EPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again later.';
    }
  }

  /// Function to fetch user details based on user id
}
