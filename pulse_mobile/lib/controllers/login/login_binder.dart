import 'package:get/get.dart';

import '../../services/auth.dart';

import '../../services/connections.dart';

import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => ApiService()); // Make sure ApiService is registered
    Get.lazyPut(() => LoginController(Get.find<AuthService>(), Get.find<ApiService>()));
  }
}