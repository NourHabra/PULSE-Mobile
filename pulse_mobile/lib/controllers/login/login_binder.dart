import 'package:get/get.dart';
import '../../services/connections.dart'; // Import the merged ApiService
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService()); // Register the merged ApiService
    Get.lazyPut(() => LoginController(Get.find<ApiService>())); // LoginController now depends only on ApiService
  }
}