// lib/controllers/login/two_factor.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart';
import 'package:pulse_mobile/models/profile_model.dart'; // Import your Profile model

class TwoFactorController extends GetxController {
  final ApiService apiService;
  final bool isEmail;
  final String emailFor2FA;
  final Rx<Profile?> authenticatedUserProfile = Rx<Profile?>(null);

  // Changed to generate 6 TextEditingControllers
  final List<TextEditingController> codeControllers = List.generate(
    6, // Now generates 6 controllers for 6 digits
        (index) => TextEditingController(),
  );
  final RxBool isLoading = false.obs;


  TwoFactorController({
    required this.apiService,
    required this.isEmail,
    required this.emailFor2FA,
  });

  String get maskedContact {
    if (isEmail) {
      final email = emailFor2FA;
      final atIndex = email.indexOf('@');
      if (atIndex > 3) {
        return email.replaceRange(3, atIndex, '*****');
      }
      return email;
    } else {
      if (emailFor2FA.length > 6) {
        return emailFor2FA.replaceRange(6, emailFor2FA.length - 3, '***');
      }
      return emailFor2FA;
    }
  }

  void deleteCode() {
    for (var i = codeControllers.length - 1; i >= 0; i--) {
      if (codeControllers[i].text.isNotEmpty) {
        codeControllers[i].text = '';
        update();
        break;
      }
    }
  }

  void onCodeChanged(String value, int index) {
    if (value.length <= 1) {
      codeControllers[index].text = value;
      // Removed Get.context! from here as it's better handled by the UI
      update(); // Trigger a rebuild for widgets observing this controller
    }
  }

  Future<void> verifyCode() async {
    final enteredCode = codeControllers.map((c) => c.text).join();

    // Changed validation to expect 6 digits
    if (enteredCode.length != 6) { // <-- Changed from 4 to 6
      Get.snackbar(
        'Error',
        'Please enter the complete 6-digit code.', // Updated message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final Profile userProfile = await apiService.postTwoFactorVerification(
        emailFor2FA,
        enteredCode,
      );

      authenticatedUserProfile.value = userProfile;
      print('OTP Verification Success: User Profile obtained: ${userProfile.email}');

      Get.snackbar(
        'Success',
        'Verification successful! Redirecting...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/home1');

    } catch (e) {
      print('OTP Verification Failed: $e');
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendCode() {
    Get.snackbar(
      'Code Resent',
      'A new verification code has been sent.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
    );
    for (var controller in codeControllers) {
      controller.clear();
    }
  }

  @override
  void onClose() {
    for (final controller in codeControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}