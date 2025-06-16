import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/connections.dart'; // Import the merged ApiService

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final ApiService apiService;
  RxBool isEmail = true.obs; // This controls the input type (Email/Phone)

  ForgotPasswordController({required this.apiService});

  Future<void> resetPassword() async {
    // This method is now specifically for sending the OTP.
    final input = emailController.text.trim();

    if (isEmail.value) {
      if (!isValidEmail(input)) {
        Get.snackbar('Error', 'Please enter a valid email address.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      isLoading.value = true;
      try {
        await apiService.sendOtpByEmail(input);
        // Navigate to verification screen ONLY AFTER successful OTP send
        Get.toNamed(
          '/verification',
          arguments: {
            'isEmail': true,
            'contact': input, // Pass the email for verification
          },
        );
      } catch (e) {
        // ApiService already shows a snackbar for errors, so no specific UI handling needed here,
        // but we catch to ensure `isLoading` is reset.
        print('Error in ForgotPasswordController.resetPassword: $e');
      } finally {
        isLoading.value = false;
      }
    } else {
      // Phone number flow (currently disabled in ApiService, but left here for completeness)
      if (!isValidPhoneNumber(input)) {
        Get.snackbar('Error', 'Please enter a valid phone number (09xxxxxxxxx).',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }
      isLoading.value = true;
      try {
        // await apiService.sendOtpByPhone(input); // If you re-enable phone OTP
        Get.snackbar('Info', 'Phone number reset is currently disabled.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.amber,
            colorText: Colors.white);
      } catch (e) {
        print('Error in ForgotPasswordController.resetPassword (phone): $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
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