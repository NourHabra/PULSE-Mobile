// lib/bindings/emergency_events_binding.dart
import 'package:get/get.dart';

import 'emergencyEvent_controller.dart';

class EmergencyEventsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EmergencyEventsController>(EmergencyEventsController());
  }
}