// lib/bindings/conditions_binding.dart

import 'package:get/get.dart';

import 'conditions_controller.dart';

class ConditionsBinding extends Bindings {
  @override
  void dependencies() {
    // Register the ConditionsController for dependency injection
    // Get.put ensures the controller is initialized and available
    Get.put<ConditionsController>(ConditionsController());
  }
}
