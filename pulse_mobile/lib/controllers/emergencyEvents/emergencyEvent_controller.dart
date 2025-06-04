// lib/controllers/emergency_events_controller.dart
import 'package:get/get.dart';

import '../../models/emergencyEvent.dart';
import '../../services/connections.dart';


class EmergencyEventsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<EmergencyEvent> emergencyEvents = <EmergencyEvent>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmergencyEvents();
  }

  Future<void> fetchEmergencyEvents() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final events = await _apiService.fetchEmergencyEvents();
      emergencyEvents.assignAll(events);
      if (events.isEmpty) {
        errorMessage.value = 'No emergency events found.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching emergency events: $e');
    } finally {
      isLoading.value = false;
    }
  }
}