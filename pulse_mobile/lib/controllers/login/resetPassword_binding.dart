import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/login/reset_newPassword_controller.dart';
import '../../services/connections.dart';

class ResetNewPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => ResetNewPasswordController(
      apiService: Get.find(),
      // Ensure arguments are not null before accessing and cast them
      email: Get.arguments['email'] as String,
      otp: Get.arguments['otp'] as String,
    ));
  }
}