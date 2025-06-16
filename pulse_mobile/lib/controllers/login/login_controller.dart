// lib/controllers/login/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart';

class LoginController extends GetxController {

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final ApiService apiService;

  LoginController(this.apiService);
////walid.busi2444@gmail.com
  @override
  void onInit() {
    super.onInit();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 5 && password.contains(RegExp(r'[0-9]'));
  }

  Future<void> loginWithCredentials(String email, String password) async {
    if (!isValidEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isValidPassword(password)) {
      Get.snackbar(
        'Error',
        'Password needs to be at least 10 characters long and contain at least one number.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final bool isLoggedIn = await apiService.login(email, password);
      isLoading.value = false;
      print('ApiService.login() returned: $isLoggedIn');
      if (isLoggedIn) {
        // Pass 'email' instead of 'contact' to the 2FA screen
        Get.offNamed('/two-factor', arguments: {'email': email, 'isEmail': true}); // Changed key to 'email'
        print('Login successful, navigating to /two-factor');
      } else {
        Get.snackbar(
          'Error',
          'Login failed. Wrong credentials maybe?',
          snackPosition: SnackPosition.BOTTOM,
        );
        print('Login failed');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error type in controller: ${e.runtimeType}');
      Get.snackbar(
        'Error',
        'Something went wrong during login in the controller: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error during login in controller: $e');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToSignUp() {
    Get.toNamed('/signup1');
    print('Navigating to Sign Up');
  }

  void forgotPassword() {
    Get.toNamed('/forgot');
    print('Navigating to Forgot Password');
  }

  void signInWithGoogle() async {
    print('Signing in with Google');
  }

  void signInWithApple() async {
    print('Signing in with Apple');
  }

  Future<void> logout() async {
    await apiService.deleteToken();
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    print('LoginController onClose called');
    super.onClose();
  }
}