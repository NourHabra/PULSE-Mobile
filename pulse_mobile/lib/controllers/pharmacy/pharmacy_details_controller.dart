// lib/controllers/pharmacy/pharmacy_details_controller.dart

import 'package:flutter/material.dart'; // Import for snackbar colors
import 'package:get/get.dart';
import '../../models/pharmacy.dart';
import '../../services/connections.dart';
import '../../models/mySavedPharmacy_model.dart';

class PharmacyDetailsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final Rx<PharmacylistModel?> pharmacy = Rx<PharmacylistModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final RxString mapUrl = ''.obs;
  final RxBool isMapLoading = false.obs;
  final RxString mapErrorMessage = ''.obs;

  final RxBool isFavorited = false.obs;
  Future<void> checkIfPharmacyIsFavorited(int pharmacyId) async {
    try {
      final List<PharmacyModel>? savedPharmacies = await _apiService.getSavedPharmacies();
      if (savedPharmacies != null) {
        isFavorited.value = savedPharmacies.any((savedPharmacy) => savedPharmacy.id == pharmacyId);
        print('Pharmacy ID $pharmacyId is favorited: ${isFavorited.value}');
      } else {
        isFavorited.value = false;
        print('No saved pharmacies found or error fetching saved pharmacies.');
      }
    } catch (e) {
      print('Error checking if pharmacy is favorited: $e');
      isFavorited.value = false;
    }
  }

  Future<void> fetchPharmacyDetails(int pharmacyId) async {
    isLoading(true);
    errorMessage('');
    isMapLoading(true);
    mapErrorMessage('');

    try {
      final fetchedPharmacy = await _apiService.fetchPharmacyDetails(pharmacyId);
      pharmacy.value = fetchedPharmacy;

      final fetchedMapUrl = await _apiService.fetchPharmacyMapUrl(pharmacyId);
      mapUrl.value = fetchedMapUrl;

      await checkIfPharmacyIsFavorited(pharmacyId);

    } catch (e) {
      errorMessage(e.toString());
      pharmacy.value = null;

      // Specific error handling for map URL fetching
      if (e.toString().contains('Failed to load pharmacy map URL')) {
        mapErrorMessage('Failed to load map: ${e.toString().split(':').last}');
        mapUrl.value = ''; // Clear map URL on error
      } else {
        // For other errors, set a general map error or keep it empty
        mapErrorMessage('An error occurred while loading map information.');
      }
    } finally {
      isLoading(false);
      isMapLoading(false);
    }
  }

  Future<void> toggleFavoriteStatus(int pharmacyId) async {
    if (isLoading.value) {
      return; // Prevent multiple rapid clicks while details are loading
    }

    // Determine if we are saving or unsaving before the optimistic update
    final bool willBeFavorited = !isFavorited.value;

    // Optimistic UI update: change state immediately
    isFavorited.value = willBeFavorited;
    print('Attempting to ${willBeFavorited ? 'save' : 'unsave'} pharmacy with ID: $pharmacyId');

    try {
      if (willBeFavorited) {
        await _apiService.savePharmacy(pharmacyId); // Call the API to save
      } else {
        await _apiService.removeSavedPharmacy(pharmacyId); // Call the API to unsave
      }

      Get.snackbar(
        'Success',
        willBeFavorited ? 'Pharmacy saved to favorites!' : 'Pharmacy removed from favorites!',
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
        'Failed to ${willBeFavorited ? 'save' : 'unsave'} pharmacy: ${e.toString().split(':').last}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor?.withOpacity(0.9) ?? Colors.red,
        colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      );
      print('Error in toggleFavoriteStatus for Pharmacy: $e');
    }
  }
}
