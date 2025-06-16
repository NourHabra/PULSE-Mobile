// controllers/profile/editProfile_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/profile_model.dart';
import '../../services/connections.dart';

class EditProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Profile?> profile = Rx<Profile?>(null);
  final Rx<XFile?> _selectedImageFile = Rx<XFile?>(null);

  XFile? get selectedImageFile => _selectedImageFile.value;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    final tokenCheck = await apiService.getToken();
    if (tokenCheck == null || tokenCheck.isEmpty) {
      errorMessage.value = 'User not authenticated. No token found.';
      isLoading.value = false;
      Get.snackbar('Error', 'Authentication token missing. Please log in again.');
      return;
    }

    try {
      profile.value = await apiService.getUserProfileEdit();
      if (profile.value != null) {
        bloodTypeController.text = profile.value?.bloodType ?? '';
        weightController.text = profile.value?.weight?.toString() ?? '';
        heightController.text = profile.value?.height?.toString() ?? '';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _selectedImageFile.value = image;
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image: $e';
      Get.snackbar('Error', errorMessage.value);
    }
  }

  Future<void> saveUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    final tokenCheck = await apiService.getToken();
    if (tokenCheck == null || tokenCheck.isEmpty) {
      errorMessage.value = 'User not authenticated. No token found to save profile.';
      isLoading.value = false;
      Get.snackbar('Error', 'Authentication token missing. Please log in again.');
      return;
    }

    // Create a Profile object containing only the fields intended for the 'dto' part.
    // The pictureUrl here is not used for the multipart file upload itself,
    // but the backend might expect it to remain if the image wasn't changed.
    final profileDataForDto = Profile(
      bloodType: bloodTypeController.text.isNotEmpty ? bloodTypeController.text : null,
      weight: double.tryParse(weightController.text),
      height: double.tryParse(heightController.text),
      // If other fields like firstName, lastName, etc. are part of the update DTO,
      // you would also include them here from their respective controllers/initial values.
      // For now, based on Postman, only bloodType, weight, height are in 'dto'.
    );

    // Get the file to be uploaded, if one was selected
    File? fileToUpload;
    if (_selectedImageFile.value != null) {
      fileToUpload = File(_selectedImageFile.value!.path);
    }

    try {
      await apiService.updateUserProfile(profileDataForDto, newProfilePicture: fileToUpload);
      Get.snackbar('Success', 'Profile updated successfully!');

      // After successful update, reload profile to get latest data from backend,
      // including the new pictureUrl if it was updated on the server.
      await loadUserProfile(); // This will refresh the profile.value and display new image

      _selectedImageFile.value = null; // Clear selected image after successful save
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to save profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    bloodTypeController.dispose();
    weightController.dispose();
    heightController.dispose();
    _selectedImageFile.close();
    super.onClose();
  }
}