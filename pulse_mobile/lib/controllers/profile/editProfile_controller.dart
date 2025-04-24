import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/profile_model.dart';
import '../../services/connections.dart';

class EditProfileController extends GetxController {
  // Get the ApiService instance
  final ApiService apiService = Get.find<ApiService>();

  // Text editing controllers for the form fields
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  // Rx variables for managing data and state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Profile?> profile = Rx<Profile?>(null); // Use Rx<Profile?>

  // Get the user token (replace with your actual token retrieval logic)
  String? _getUserToken() {
    //  SharedPreferences,  Secure Storage, or from GetX.
    //  For example:
    // return Get.find<AuthController>().user.value?.authToken;
    return "dummy_user_token"; // Replace with actual token retrieval
  }

  @override
  void onInit() {
    super.onInit();
    loadUserProfile(); // Load profile data when the controller is initialized
  }

  // Load User Profile Data
  Future<void> loadUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    final token = _getUserToken();
    if (token == null) {
      errorMessage.value = 'User not authenticated.';
      isLoading.value = false;
      return;
    }

    try {
      profile.value = await apiService.getUserProfileEdit(token); // Await the result
      if (profile.value != null) {
        // Populate the text fields with the loaded data
        bloodTypeController.text = profile.value?.bloodType ?? '';
        weightController.text = profile.value?.weight?.toString() ?? '';
        heightController.text = profile.value?.height?.toString() ?? '';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Update User Profile Data
  Future<void> saveUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    final token = _getUserToken();
    if (token == null) {
      errorMessage.value = 'User not authenticated.';
      isLoading.value = false;
      return;
    }

    // Create a Profile object from the form data
    final updatedProfile = Profile(
      bloodType: bloodTypeController.text,
      weight: double.tryParse(weightController.text),
      height: double.tryParse(heightController.text),
      // Keep the existing picture URL.
      pictureUrl: profile.value?.pictureUrl, // important
    );

    try {
      await apiService.updateUserProfile(token, updatedProfile);
      // Optionally, show a success message
      Get.snackbar('Success', 'Profile updated successfully!');
      // Update the local profile data
      profile.value = updatedProfile;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose the controllers
    bloodTypeController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.onClose();
  }
}
