import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/connections.dart'; // Import ApiService

class ChangePasswordController extends GetxController {
  // Get the ApiService instance
  final ApiService apiService = Get.find<ApiService>();

  // Form controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  // Rx variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  final RxBool showOldPassword = false.obs;
  final RxBool showNewPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;

  Future<String?> _getUserToken() {
    return apiService.getToken();
  }

  // Function to handle the password change
  Future<void> changePassword() async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    // Input validation
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields.';
      isLoading.value = false;
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage.value = 'New password and confirmation do not match.';
      isLoading.value = false;
      return;
    }

    //  Get the user's token.
    String? userToken = await _getUserToken(); // Await the getToken()
    if (userToken == null) {
      errorMessage.value = 'User token not found. Please log in again.';
      isLoading.value = false;
      return;
    }

    try {
      // Call the changePassword method from ApiService
      final response = await apiService.changePassword(
        // Make sure ApiService.changePassword has userToken
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (response['success'] == true) {
        successMessage.value = response['message'];
        // Clear the form fields on success
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        //  Consider navigating to a success screen or showing a dialog.
        // Get.to(()=> PasswordChangedSuccessfully());
      } else {
        errorMessage.value = response['message'] ??
            'Failed to change password. Please try again.';
      }
    } catch (error) {
      errorMessage.value = 'Error: ${error.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose of controllers
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
