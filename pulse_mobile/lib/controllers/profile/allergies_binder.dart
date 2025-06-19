// lib/bindings/allergies_binding.dart

import 'package:get/get.dart';

import 'allergies_contorller.dart';

class AllergiesBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put ensures the controller is initialized and available
    Get.put<AllergiesController>(AllergiesController());
  }
}
