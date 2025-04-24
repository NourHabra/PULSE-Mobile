import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/services/auth.dart';
import 'package:pulse_mobile/services/connections.dart'; // Import ApiService

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final AuthService authService;
  final ApiService apiService; // Get ApiService Instance

  LoginController(this.authService, this.apiService); // Updated constructor

  @override
  void onInit() {
    super.onInit();
// No need to check login status here anymore. That logic should be
// in a Splash/Initial controller or similar.
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    if (password.length < 10) {
      return false;
    }
    return true;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!isValidEmail(email)) {
      Get.snackbar(
        'Error',
        'Gotta enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isValidPassword(password)) {
      Get.snackbar(
        'Error',
        'Password needs to be 10 characters with at least one number .',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final bool? authToken = await authService.login(email, password); // Change to bool?
      if (authToken == true) { // Check the boolean value directly
        isLoading.value = false;
        Get.offAllNamed('/home');
        print(authToken);
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Login failed. Wrong credentials maybe?',
          snackPosition: SnackPosition.BOTTOM,
        );
        print(authToken);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Something went wrong during login ',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToSignUp() {
    Get.toNamed('/sigup');
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

// logout (moved to ApiService)
  Future<void> logout() async {
    await apiService.deleteToken(); // Use the ApiService to delete.
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
