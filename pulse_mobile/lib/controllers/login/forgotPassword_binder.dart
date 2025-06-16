import 'package:get/get.dart';
import '../../services/connections.dart';
import 'forgotPassword_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService()); // Register ApiService as a lazy-put dependency
    Get.lazyPut(() => ForgotPasswordController(
        apiService: Get.find())); // Inject ApiService into the controller
  }
}