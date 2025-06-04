// lib/bindings/emergency_events_binding.dart
import 'package:get/get.dart';

import 'emergencyEvent_controller.dart';

class EmergencyEventsBinding extends Bindings {
  @override
  void dependencies() {
    // If ApiService was not added globally in main, ensure it's available here too.
    // Get.lazyPut<ApiService>(() => ApiService()); // Only if not already put globally or by other bindings.
    Get.put<EmergencyEventsController>(EmergencyEventsController());
  }
}