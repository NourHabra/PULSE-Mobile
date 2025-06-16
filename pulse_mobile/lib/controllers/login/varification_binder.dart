import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/login/varification_controller.dart';
import '../../services/connections.dart';

class VerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => VerificationController(
      apiService: Get.find(),
      // Ensure arguments are not null before accessing
      isEmail: Get.arguments['isEmail'] as bool,
      contact: Get.arguments['contact'] as String,
    ));
  }
}