// lib/screens/login_screens/login_redirect_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRedirectScreen extends StatelessWidget {
  const LoginRedirectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Schedule the navigation to happen after the current build cycle completes.
    // This ensures the LoginRedirectScreen is fully built and attached before it triggers navigation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[LoginRedirectScreen] Navigating to /login via offAllNamed');
      Get.offAllNamed('/login'); // Navigate to the actual login page
    });

    // Show a simple loading indicator or just an empty container while redirecting
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}