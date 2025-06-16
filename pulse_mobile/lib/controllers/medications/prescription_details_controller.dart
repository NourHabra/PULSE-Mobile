import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart'; // Ensure ApiService is correctly imported
import 'package:pulse_mobile/models/prescription_details.dart'; // Ensure PrescriptionDetailsInfo is correctly imported

class PrescriptionDetailsController extends GetxController {
  // Make apiService a final field initialized via the constructor
  final ApiService apiService; // This field will hold the injected ApiService instance

  var prescription = Rx<PrescriptionDetailsInfo?>(null);
  var isLoading = true.obs;
  var hasError = false.obs;

  // Define a constructor that takes ApiService as a required named parameter
  PrescriptionDetailsController({required this.apiService}); // <--- THIS IS THE CRUCIAL CHANGE

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
