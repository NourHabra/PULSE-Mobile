import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final AuthService authService;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  RxBool isEmail = true.obs;

  ForgotPasswordController({required this.authService});

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
        await authService.resetPasswordByEmail(input);
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
        await authService.resetPasswordByPhone(input);
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
    isLoading.value = false; // Moved here to ensure it's set after the try-catch block
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
