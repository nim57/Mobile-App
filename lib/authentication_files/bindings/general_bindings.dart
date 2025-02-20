import 'package:echo_project_123/authentication_files/featuers/authentication/controllers/signup/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
