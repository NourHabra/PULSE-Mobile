import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/LabModel.dart';
import '../../services/connections.dart';
// Controller
class LabController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  RxList<LabModel> labs = <LabModel>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  // Search related
  TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  // Initialize filteredLabs directly at declaration
  RxList<LabModel> filteredLabs = <LabModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    ever(labs, (_) => _filterLabs());
    // 'debounce' for search query to avoid too frequent updates while typing
    debounce(searchQuery, (_) => _filterLabs(), time: const Duration(milliseconds: 300));

    // Fetch initial data
    fetchLabs();

    // Listen to changes in the search text field
    searchController.addListener(() {
      updateSearchQuery(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Method to filter labs based on current state
  void _filterLabs() {
    if (searchQuery.isEmpty) {
      filteredLabs.assignAll(labs); // If no query, show all labs
    } else {
      final lowerCaseQuery = searchQuery.value.toLowerCase();
      filteredLabs.assignAll(labs.where((lab) {
        // Case-insensitive search on name and address
        return lab.name.toLowerCase().contains(lowerCaseQuery) ||
            lab.address.toLowerCase().contains(lowerCaseQuery);
      }).toList());
    }
  }

  Future<void> fetchLabs() async {
    isLoading(true);
    errorMessage('');
    try {
      final fetchedLabs = await apiService.fetchLabs();
      labs.assignAll(fetchedLabs); // This will trigger the 'ever(labs, ...)' listener
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }

  }
}
