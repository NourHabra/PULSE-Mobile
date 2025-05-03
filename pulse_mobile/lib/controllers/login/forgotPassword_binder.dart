import 'package:get/get.dart';
import '../../services/connections.dart'; // Import the merged ApiService
import 'forgotPassword_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService()); // Register the merged ApiService
    Get.lazyPut(() => ForgotPasswordController(
        apiService: Get.find())); // Inject ApiService
  }
}