import 'package:get/get.dart';
import '../../models/medical_record_details_model.dart';
import '../../services/connections.dart'; // Ensure this path is correct

class MedicalRecordDetailsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final Rx<MedicalRecordDetails?> medicalRecordDetails = Rx<MedicalRecordDetails?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final int medicalRecordId;

  MedicalRecordDetailsController({required this.medicalRecordId});

  @override
  void onInit() {
    super.onInit();
    fetchMedicalRecordDetails();
  }

  Future<void> fetchMedicalRecordDetails() async {
    try {
      isLoading(true);
      errorMessage('');
      // Assuming getMedicalRecordDetails method in ApiService handles the API call and returns a parsed MedicalRecordDetails object
      final details = await _apiService.getMedicalRecordDetails(medicalRecordId);
      medicalRecordDetails.value = details;
    } catch (e) {
      errorMessage('Failed to load medical record details. Error: $e');
      print('Error in MedicalRecordDetailsController: $e');
    } finally {
      isLoading(false);
    }
  }
}