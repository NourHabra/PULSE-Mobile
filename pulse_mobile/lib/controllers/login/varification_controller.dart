import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/connections.dart'; // Ensure ApiService is correctly imported

class VerificationController extends GetxController {
  final ApiService apiService;

  final RxBool _isEmail;
  final String _contact; // The original contact (email/phone number)
  final RxBool isLoading = false.obs;

  // Use this for informational messages that CAN be shown on screen
  final RxString infoMessage = ''.obs;

  bool get isEmail => _isEmail.value;
  String get contact => _contact;

  final List<TextEditingController> codeControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

  String get maskedContact {
    if (_isEmail.value) {
      final email = _contact;
      final atIndex = email.indexOf('@');
      if (atIndex > 3) {
        return email.replaceRange(3, atIndex, '*****');
      }
      return email;
    }
    // Simple masking for phone number (e.g., last 4 digits visible)
    if (_contact.length > 4) {
      return '******${_contact.substring(_contact.length - 4)}';
    }
    return _contact; // Fallback for very short numbers
  }

  VerificationController({required this.apiService, required bool isEmail, required String contact})
      : _isEmail = isEmail.obs,
        _contact = contact;

  @override
  void onInit() {
    super.onInit();
    print("VerificationController initialized with isEmail=${_isEmail.value}, contact=$_contact");
  }

  void onCodeChanged(String value, int index, BuildContext context) {
    infoMessage.value = ''; // Clear any previous info message on code change
    if (value.isNotEmpty) {
      if (index < codeControllers.length - 1) {
        FocusScope.of(context).nextFocus();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  Future<void> proceedToPasswordReset() async {
    final enteredCode = codeControllers.map((c) => c.text).join();

    if (enteredCode.length != 6) {
      Get.snackbar('Error', 'Please enter the complete 6-digit code.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    // No direct API call here, just navigation with data.
    // The actual password reset API call happens on the next screen.
    Get.offNamed(
      '/reset-new-password',
      arguments: {
        'email': _contact, // Pass the original contact (email)
        'otp': enteredCode, // Pass the entered OTP
      },
    );
    isLoading.value = false; // Reset loading state after navigation
  }

  Future<void> resendCode() async {
    isLoading.value = true;
    infoMessage.value = ''; // Clear any previous info message

    try {
      if (_isEmail.value) {
        await apiService.sendOtpByEmail(_contact);
        // This is an informational message, so we'll allow it on screen
        infoMessage.value = 'A new verification code has been sent to your email.';
      } else {
        // This is an informational message, so we'll allow it on screen
        infoMessage.value = 'Resending OTP to phone is currently disabled or not implemented.';
      }
    } catch (e) {
      // ApiService already shows a snackbar for errors
      print('Resend Code API Error: $e');
    } finally {
      isLoading.value = false;
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