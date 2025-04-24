import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/profile/changePassword_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
  }
}
