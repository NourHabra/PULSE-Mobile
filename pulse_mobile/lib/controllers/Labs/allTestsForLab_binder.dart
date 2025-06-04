// lib/bindings/all_tests_for_lab_binding.dart
import 'package:get/get.dart';

import 'package:pulse_mobile/controllers/Labs/allTestsForLab_controller.dart'; // Adjust path as needed (where ApiService is located)

class AllTestsForLabBinding implements Bindings {
  @override
  void dependencies() {
    // This ensures AllTestsForLabController is initialized when the route is accessed.
    // It can now safely find ApiService, which is already Get.put() in main.dart.
    Get.lazyPut<AllTestsForLabController>(() => AllTestsForLabController());
  }
}
