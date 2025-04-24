import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/login/varification_controller.dart';

import '../../services/connections.dart';

class VerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => VerificationController(
      apiService: Get.find(), // Inject ApiService
      isEmail: Get.arguments['isEmail'],
      contact: Get.arguments['contact'],
    ));
  }
}