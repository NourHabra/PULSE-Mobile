import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/mySavedDoctor_model.dart';
import '../../services/connections.dart';
import '../../models/generalDoctorModel.dart';

class DoctorDetailsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  Rx<GeneralDoctor?> doctor = Rx<GeneralDoctor?>(null);
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  RxString mapUrl = ''.obs;
  RxBool isMapLoading = false.obs;
  RxString mapErrorMessage = ''.obs;

  RxBool isFavorited = false.obs;

  Future<void> checkIfDoctorIsFavorited(int doctorId) async {
    try {
      final List<SavedDoctorModel>? savedDoctors = await _apiService.getSavedDoctors();
      if (savedDoctors != null) {
        isFavorited.value = savedDoctors.any((savedDoctor) => savedDoctor.doctorUserId == doctorId);
        print('Doctor ID $doctorId is favorited: ${isFavorited.value}');
      } else {
        isFavorited.value = false; // No saved doctors or error fetching, so not favorited
        print('No saved doctors found or error fetching saved doctors.');
      }
    } catch (e) {
      print('Error checking if doctor is favorited: $e');
      isFavorited.value = false; // Default to false on error
    }
  }

  Future<void> fetchDoctorDetails(int doctorId) async {
    isLoading(true);
    errorMessage('');
    isMapLoading(true);
    mapErrorMessage('');
    try {
      doctor.value = await _apiService.fetchDoctorDetails(doctorId);
      mapUrl.value = await _apiService.fetchDoctorMapUrl(doctorId); // This is for the embed preview

      // After fetching doctor details, immediately check its favorite status
      await checkIfDoctorIsFavorited(doctorId);

    } catch (e) {
      errorMessage(e.toString());
      doctor.value = null;
      if (e is! Exception || e.toString().contains('Failed to load doctor map URL')) {
        mapErrorMessage(e.toString());
      }
    } finally {
      isLoading(false);
      isMapLoading(false);
    }
  }

  Future<void> toggleFavoriteStatus(int doctorId) async {
    if (isLoading.value) {
      return;
    }

    // Determine if we are saving or unsaving before the optimistic update
    final bool willBeFavorited = !isFavorited.value;

    // Optimistic UI update
    isFavorited.value = willBeFavorited;
    print('Attempting to ${isFavorited.value ? 'save' : 'unsave'} doctor with ID: $doctorId');

    try {

      if (willBeFavorited) {
        await _apiService.saveDoctor(doctorId);
      } else {
        await _apiService.removeSavedDoctor(doctorId);
      }

      Get.snackbar(
        'Success',
        willBeFavorited ? 'Doctor saved to favorites!' : 'Doctor removed from favorites!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor?.withOpacity(0.9) ?? Colors.green,
        colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      );
    } catch (e) {
      isFavorited.value = !willBeFavorited;
      errorMessage(e.toString());
      Get.snackbar(
        'Error',
        'Failed to ${willBeFavorited ? 'save' : 'unsave'} doctor: ${e.toString().split(':').last}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.snackBarTheme.backgroundColor?.withOpacity(0.9) ?? Colors.red,
        colorText: Get.theme.snackBarTheme.actionTextColor ?? Colors.white,
      );
      print('Error in toggleFavoriteStatus: $e');
    }
  }
}