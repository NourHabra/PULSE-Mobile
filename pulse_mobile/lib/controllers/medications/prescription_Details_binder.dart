import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/medications/prescription_details_controller.dart';
import 'package:pulse_mobile/services/connections.dart'; // Assuming ApiService is here

class PrescriptionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiService is registered if not already
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => PrescriptionDetailsController(
      apiService: Get.find<ApiService>(), // <--- Explicitly specify ApiService type here
    ));
  }
}
