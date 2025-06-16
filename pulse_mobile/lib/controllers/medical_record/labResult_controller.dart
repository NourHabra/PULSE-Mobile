import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart';

import '../../models/LabResultDeatils.dart'; // Make sure this path is correct

class LabResultDetailsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final int labResultId;
  final Rx<LabResultDetails?> labResultDetails = Rx<LabResultDetails?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  LabResultDetailsController({required this.labResultId});

  @override
  void onInit() {
    super.onInit();
    fetchLabResultDetails();
  }

  Future<void> fetchLabResultDetails() async {
    isLoading(true);
    errorMessage('');
    try {
      final fetchedDetails = await _apiService.getLabResultDetails(labResultId);
      labResultDetails.value = fetchedDetails;
    } catch (e) {
      errorMessage('Failed to load lab result details: ${e.toString()}');
      print('Error in LabResultDetailsController.fetchLabResultDetails: $e');
    } finally {
      isLoading(false);

    }
  }

  Future<void> refreshLabResultDetails() async {
    await fetchLabResultDetails();
  }
}