import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/connections.dart'; // Import the merged ApiService

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final ApiService apiService; // Use ApiService
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  RxBool isEmail = true.obs;

  ForgotPasswordController({required this.apiService}); // Update the constructor

  Future<void> resetPassword() async {
    final input = emailController.text.trim();

    if (isEmail.value) {
      if (!isValidEmail(input)) {
        Get.snackbar('Error', 'Please enter a valid email address.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      isLoading.value = true;
      try {
        await apiService.resetPasswordByEmail(input); // Use apiService
        // Navigate to verification screen after successful email request
        Get.toNamed(
          '/verification',
          arguments: {
            'isEmail': true,
            'contact': input,
          },
        );
      } catch (e) {
        isLoading.value = false;
        return;
      }
    } else {
      if (!isValidPhoneNumber(input)) {
        Get.snackbar('Error', 'Please enter a valid phone number (09xxxxxxxxx).',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      isLoading.value = true;
      try {
        await apiService.resetPasswordByPhone(input); // Use apiService
        // Navigate to verification screen after successful phone request
        Get.toNamed(
          '/verification',
          arguments: {
            'isEmail': false,
            'contact': input,
          },
        );
      } catch (e) {
        isLoading.value = false;
        return;
      }
    }
    isLoading.value = false;
  }

  bool isValidEmail(String email) {
    final emailRegex =
    RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    // Starts with 09 and has a total of 10 digits
    return RegExp(r'^09\d{8}$').hasMatch(phone);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}