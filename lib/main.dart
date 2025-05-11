import 'package:echo_project_123/authentication_files/data/repositories/authentication/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'Home_sereens/item_backend/item_controller.dart';
import 'Home_sereens/review_backend/review_controler.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // WIDGETS Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Todo: init local Storage
  await GetStorage.init();

  
  // Then register ReviewController
  Get.lazyPut(() => ReviewController());
  

  // Add global error handler
  FlutterError.onError = (details) {
    if (details.exception.toString().contains('cloud_firestore')) {
      // Handle Firestore errors globally
    }
  };
  
 
  
  // -- Awate Splash unitl others items Load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Todo: Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  runApp(const App());
}
