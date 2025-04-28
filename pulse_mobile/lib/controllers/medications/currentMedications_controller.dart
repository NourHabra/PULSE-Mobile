
import 'package:get/get.dart';
import '../../models/medicationModel.dart';
import '../../services/connections.dart';


class CurrentMedicationsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  RxList<Medication> medications = <Medication>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentMedications();
  }

  Future<void> fetchCurrentMedications() async {
    isLoading(true);
    errorMessage('');
    try {
      final List<Medication> fetchedMedications = await _apiService.getCurrentMedications();
      medications.assignAll(fetchedMedications);
    } catch (e) {
      errorMessage('Failed to load medications: $e');
    } finally {
      isLoading(false);
    }
  }
}