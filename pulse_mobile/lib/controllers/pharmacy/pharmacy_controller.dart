// lib/controllers/pharmacy/pharmacy_controller.dart

import 'package:flutter/material.dart'; // Required for TextEditingController
import 'package:get/get.dart';

import '../../models/pharmacy.dart';
import '../../services/connections.dart';


// PharmacyController extends GetxController to manage pharmacy data.
class PharmacyController extends GetxController {
  // Observable list of PharmacyModel objects. RxList automatically rebuilds widgets when it changes.
  final RxList<PharmacylistModel> pharmacies = <PharmacylistModel>[].obs;
  // Observable boolean to indicate if data is currently being loaded.
  final RxBool isLoading = true.obs;
  // Observable string to store any error messages.
  final RxString errorMessage = ''.obs;


  // New: TextEditingController for the search input field.
  final TextEditingController searchController = TextEditingController();
  // New: Observable string to hold the current search query.
  final RxString searchQuery = ''.obs;
  // New: Observable list to hold pharmacies filtered by the search query.
  // Initialized directly to an empty RxList.
  final RxList<PharmacylistModel> filteredPharmacies = <PharmacylistModel>[].obs;

  // Get an instance of ApiService using Get.find() to access its methods.
  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    // When the controller is initialized, fetch the pharmacies.
    fetchPharmacies();

    // Listen for changes in the 'pharmacies' list and the 'searchQuery'.
    // Whenever 'pharmacies' changes (e.g., after fetching), trigger a filter.
    ever(pharmacies, (_) => _filterPharmacies());

    // Debounce the 'searchQuery' changes to avoid excessive filtering while typing.
    // The filter will only run 300 milliseconds after the user stops typing.
    debounce(searchQuery, (_) => _filterPharmacies(), time: const Duration(milliseconds: 300));

    // Listen to changes in the search text field and update the observable searchQuery.
    searchController.addListener(() {
      updateSearchQuery(searchController.text);
    });
  }

  @override
  void onClose() {
    // Dispose the TextEditingController when the controller is closed to prevent memory leaks.
    searchController.dispose();
    super.onClose();
  }

  // Method to update the search query. This will trigger the debounce.
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Method to filter pharmacies based on the current search query.
  void _filterPharmacies() {
    if (searchQuery.isEmpty) {
      // If the search query is empty, show all fetched pharmacies.
      filteredPharmacies.assignAll(pharmacies);
    } else {
      // Convert the search query to lowercase for case-insensitive comparison.
      final lowerCaseQuery = searchQuery.value.toLowerCase();
      // Filter the main 'pharmacies' list.
      filteredPharmacies.assignAll(pharmacies.where((pharmacy) {
        // Check if the pharmacy name or address contains the search query.
        return pharmacy.name.toLowerCase().contains(lowerCaseQuery) ||
            pharmacy.address.toLowerCase().contains(lowerCaseQuery);
      }).toList()); // Convert the iterable to a list and assign it.
    }
  }

  // Asynchronous method to fetch pharmacies from the API.
  Future<void> fetchPharmacies() async {
    isLoading.value = true; // Set loading to true before starting the fetch.
    errorMessage.value = ''; // Clear any previous error messages.
    try {
      // Call the fetchPharmacies method from ApiService.
      final fetchedPharmacies = await _apiService.fetchPharmacies();
      // Update the observable list with the fetched data.
      // This assignment will automatically trigger the 'ever(pharmacies, ...)' listener.
      pharmacies.assignAll(fetchedPharmacies);
    } catch (e) {
      // If an error occurs, update the error message.
      errorMessage.value = 'Failed to load pharmacies: ${e.toString()}';
      print('Error in PharmacyController: ${e.toString()}');
    } finally {
      // Regardless of success or failure, set loading to false when done.
      isLoading.value = false;
    }
  }
}
