import 'package:get/get.dart';
import '../../services/auth.dart';
import 'forgotPassword_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => ForgotPasswordController(
        authService: Get.find())); // Inject AuthService
  }
}