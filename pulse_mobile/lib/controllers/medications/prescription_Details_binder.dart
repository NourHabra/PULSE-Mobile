import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/medications/prescription_details_controller.dart';
import 'package:pulse_mobile/services/connections.dart';

class PrescriptionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => PrescriptionDetailsController(
      apiService: Get.find<ApiService>(),
    ));
  }
}
