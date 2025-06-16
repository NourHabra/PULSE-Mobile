import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/connections.dart'; // Import ApiService

class ResetNewPasswordController extends GetxController {
  final ApiService apiService;
  final String email; // The email from the verification screen
  final String otp; // The OTP from the verification screen

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  ResetNewPasswordController({required this.apiService, required this.email, required this.otp});

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> performPasswordReset() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please enter both new and confirm passwords.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (newPassword.length < 6) { // Example: minimum password length
      Get.snackbar('Error', 'Password must be at least 6 characters long.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      await apiService.resetPassword(email, otp, newPassword);
      // If the API call is successful, the ApiService will show a success snackbar.
      // Then, navigate to the login screen, clearing the navigation stack.
      Get.offAllNamed('/login');
    } catch (e) {
      // ApiService already shows an error snackbar.
      // The `isLoading` will be set to false in the `finally` block.
      print('Error in ResetNewPasswordController.performPasswordReset: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}