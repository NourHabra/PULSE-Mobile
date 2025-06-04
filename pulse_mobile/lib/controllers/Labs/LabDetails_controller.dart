// lib/controllers/Labs/LabDetails_controller.dart
import 'package:flutter/material.dart'; // Import for snackbar colors
import 'package:get/get.dart';

import '../../models/LabModel.dart';
import '../../models/labTestModel.dart';
import '../../models/mySavedLab_model.dart'; // Import your SavedLaboratoryModel
import '../../services/connections.dart';

class LabDetailsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  Rx<LabModel?> lab = Rx<LabModel?>(null);
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  RxString mapEmbedUrl = ''.obs;
  RxList<LabTestModel> labTests = <LabTestModel>[].obs; // New: List for lab tests
  RxBool isTestsLoading = true.obs; // New: Loading state for tests
  RxString testsErrorMessage = ''.obs; // New: Error message for tests

  RxBool isFavorited = false.obs; // NEW: Observable for favorite status

  // NEW: Method to check if the current lab is favorited
  Future<void> checkIfLabIsFavorited(int labId) async {
    try {
      final List<SavedLaboratoryModel>? savedLabs = await _apiService.getSavedLaboratories();
      if (savedLabs != null) {
        // IMPORTANT: Compare labId with savedLab.id (assuming 'id' getter in SavedLaboratoryModel returns laboratoryId)
        isFavorited.value = savedLabs.any((savedLab) => savedLab.laboratoryId == labId);
        print('Lab ID $labId is favorited: ${isFavorited.value}');
      } else {
        isFavorited.value = false; // No saved labs or error fetching, so not favorited
        print('No saved labs found or error fetching saved labs.');
      }
    } catch (e) {
      print('Error checking if lab is favorited: $e');
      isFavorited.value = false; // Default to false on error
    }
  }


  Future<void> fetchLabDetails(int labId) async {
    isLoading(true);
    errorMessage('');
    mapEmbedUrl('');
    isTestsLoading(true);
    testsErrorMessage('');
    try {
      lab.value = await _apiService.fetchLabById(labId);
      mapEmbedUrl.value = await _apiService.fetchLabEmbedCoordinates(labId);
      labTests.assignAll(await _apiService.fetchLabTests(labId));

      // NEW: After fetching lab details, immediately check its favorite status
      await checkIfLabIsFavorited(labId);

    } catch (e) {
      errorMessage(e.toString());
      lab.value = null;
      mapEmbedUrl('');
      testsErrorMessage(e.toString());
    } finally {
      isLoading(false);
      isTestsLoading(false);
    }
  }

  // NEW: Toggle Favorite Status for Labs
  Future<void> toggleFavoriteStatus(int labId) async {
    if (isLoading.value) {
      return; // Prevent multiple rapid clicks while details are loading
    }

    // Determine if we are saving or unsaving before the optimistic update
    final bool willBeFavorited = !isFavorited.value;

    // Optimistic UI update: change state immediately
    isFavorited.value = willBeFavorited;
    print('Attempting to ${willBeFavorited ? 'save' : 'unsave'} lab with ID: $labId');

    try {
      if (willBeFavorited) {
        await _apiService.saveLab(labId); // Call the API to save
      } else {
        await _apiService.removeSavedLaboratory(labId); // Call the API to unsave
      }

      Get.snackbar(
        'Success',
        willBeFavorited ? 'Laboratory saved to favorites!' : 'Laboratory removed from favorites!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor?.withOpacity(0.9) ?? Colors.green,
        colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      );
    } catch (e) {
      // Revert optimistic update on error
      isFavorited.value = !willBeFavorited;
      errorMessage(e.toString());
      Get.snackbar(
        'Error',
        'Failed to ${willBeFavorited ? 'save' : 'unsave'} laboratory: ${e.toString().split(':').last}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor?.withOpacity(0.9) ?? Colors.red,
        colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      );
      print('Error in toggleFavoriteStatus for Lab: $e');
    }
  }
}