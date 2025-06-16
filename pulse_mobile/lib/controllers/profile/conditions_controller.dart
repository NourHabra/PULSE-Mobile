// lib/controllers/conditions/conditions_controller.dart

import 'package:get/get.dart';
import '../../models/chronic_disease_model.dart'; // Import the new model
import '../../services/connections.dart'; // Ensure ApiService is available

class ConditionsController extends GetxController {
  // Instance of ApiService to make API calls
  final ApiService _apiService = Get.find<ApiService>();

  // Observable list of ChronicDiseaseModel objects
  final RxList<ChronicDiseaseModel> conditions = <ChronicDiseaseModel>[].obs;
  // Observable boolean to indicate if data is currently being loaded
  final RxBool isLoading = true.obs;
  // Observable string to store any error messages
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch conditions when the controller is initialized
    fetchConditions();
  }

  // Asynchronous method to fetch chronic diseases from the API
  Future<void> fetchConditions() async {
    isLoading.value = true; // Set loading to true
    errorMessage.value = ''; // Clear any previous error messages
    try {
      // Call the new method from ApiService to fetch chronic diseases
      final fetchedConditions = await _apiService.fetchChronicDiseases();
      conditions.assignAll(fetchedConditions); // Update the observable list

      // If no conditions are found, set a specific message
      if (fetchedConditions.isEmpty) {
        errorMessage.value = 'No chronic conditions found.';
      }
    } catch (e) {
      // If an error occurs, update the error message
      errorMessage.value = 'Failed to load conditions: ${e.toString()}';
      print('Error in ConditionsController: ${e.toString()}');
    } finally {
      isLoading.value = false; // Set loading to false when done
    }
  }
}
