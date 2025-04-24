// lib/controllers/verification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/connections.dart'; // Import ApiService

class VerificationController extends GetxController {
  final ApiService apiService;
  final bool isEmail;
  final String contact;

  final List<TextEditingController> codeControllers = List.generate(
    4,
        (index) => TextEditingController(),
  );
  final RxBool isLoading = false.obs;
  String get maskedContact {
    if (isEmail) {
      final email = contact;
      final atIndex = email.indexOf('@');
      if (atIndex > 3) {
        return email.replaceRange(3, atIndex, '*****');
      }
      return email;
    } else {
      if (contact.length > 6) {
        return contact.replaceRange(6, contact.length - 3, '***');
      }
      return contact;
    }
  }

  VerificationController({required this.apiService, required this.isEmail, required this.contact});


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
      if (value.isNotEmpty && index < 3) {
        //  implement focus nodes.
      }
      update();
    }
  }

  Future<void> verifyCode() async {
    final enteredCode = codeControllers.map((c) => c.text).join();

    if (enteredCode.length != 4) {
      Get.snackbar('Error', 'Please enter the complete code.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    if (enteredCode == '1234') {
      Get.offNamed('/reset-new-password');
    } else {
      Get.snackbar('Error', 'Invalid verification code. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void resendCode() {
    Get.snackbar('Code Resent', 'A new verification code has been sent.',
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    for (final controller in codeControllers) {
      controller.dispose();
    }
    super.onClose();
  }



}

