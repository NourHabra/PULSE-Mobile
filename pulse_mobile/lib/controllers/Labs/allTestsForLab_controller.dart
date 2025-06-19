import 'package:get/get.dart';
import '../../models/labTestModel.dart';
import '../../services/connections.dart';

class AllTestsForLabController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>(); // Get the ApiService instance
  final RxList<LabTestModel> allLabTests = <LabTestModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  late int labId; // Will be initialized from arguments

  @override
  void onInit() {
    super.onInit();
    // Get the labId passed from LabDetailsScreen
    if (Get.arguments != null && Get.arguments['labId'] != null) {
      labId = Get.arguments['labId'] as int;
      fetchAllTests(labId);
    } else {
      errorMessage.value = 'Lab ID not provided.';
    }
  }

  Future<void> fetchAllTests(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<LabTestModel> fetchedTests = await _apiService.fetchLabTests(id);
      allLabTests.assignAll(fetchedTests); // Assign all fetched tests
    } catch (e) {
      errorMessage.value = 'Failed to load all tests: $e';
      print('Error fetching all lab tests: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
