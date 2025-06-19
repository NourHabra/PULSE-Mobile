import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart';
import 'package:pulse_mobile/models/prescription_details.dart';

class PrescriptionDetailsController extends GetxController {
  final ApiService apiService;

  var prescription = Rx<PrescriptionDetailsInfo?>(null);
  var isLoading = true.obs;
  var hasError = false.obs;

  PrescriptionDetailsController({required this.apiService});

  @override
  void onInit() {
    super.onInit();
    final int? prescriptionId = Get.arguments as int?;
    if (prescriptionId != null) {
      fetchPrescriptionDetails(prescriptionId);
    } else {
      hasError.value = true;
      Get.snackbar('Error', 'Prescription ID not provided.', snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  Future<void> fetchPrescriptionDetails(int id) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Use the injected apiService from the constructor
      final fetchedPrescription = await apiService.getPrescription(id);

      if (fetchedPrescription != null) {
        prescription.value = fetchedPrescription;
      } else {
        hasError.value = true;
        Get.snackbar('Error', 'No prescription data received for ID $id.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar('Error', 'Failed to load prescription details: $e', snackPosition: SnackPosition.BOTTOM);
      print('Error fetching prescription details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
