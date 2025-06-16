import 'package:get/get.dart';
import '../../models/allergies.dart';
import '../../services/connections.dart'; // Ensure ApiService is available

class AllergiesController extends GetxController {
  // Instance of ApiService to make API calls
  final ApiService _apiService = Get.find<ApiService>();

  // Observable list of AllergyModel objects
  final RxList<AllergyModel> allergies = <AllergyModel>[].obs;
  // Observable boolean to indicate if data is currently being loaded
  final RxBool isLoading = true.obs;
  // Observable string to store any error messages
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch allergies when the controller is initialized
    fetchAllergies();
  }

  // Asynchronous method to fetch allergies from the API
  Future<void> fetchAllergies() async {
    isLoading.value = true; // Set loading to true
    errorMessage.value = ''; // Clear any previous error messages
    try {
      // Call the new method from ApiService to fetch allergies
      final fetchedAllergies = await _apiService.fetchAllergies();
      allergies.assignAll(fetchedAllergies); // Update the observable list

      // If no allergies are found, set a specific message
      if (fetchedAllergies.isEmpty) {
        errorMessage.value = 'No known allergies found.';
      }
    } catch (e) {
      // If an error occurs, update the error message
      errorMessage.value = 'Failed to load allergies: ${e.toString()}';
      print('Error in AllergiesController: ${e.toString()}');
    } finally {
      isLoading.value = false; // Set loading to false when done
    }
  }
}