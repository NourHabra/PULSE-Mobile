import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SplashController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    checkAuthAndNavigate();
  }

  Future<void> checkAuthAndNavigate() async {
    // Simulate some initial app loading if needed
    await Future.delayed(const Duration(seconds: 2));

    final authToken = await _secureStorage.read(key: 'authToken');

    if (authToken != null && authToken.isNotEmpty) {
      // Optional: Validate the token with the backend
      // try {
      //   final isValid = await _authService.validateToken(authToken);
      //   if (isValid) {
      //     Get.offAllNamed(AppRoutes.HOME);
      //   } else {
      //     Get.offAllNamed(AppRoutes.LOGIN);
      //   }
      // } catch (e) {
      //   Get.offAllNamed(AppRoutes.LOGIN); // Handle potential errors
      // }
      Get.offAllNamed('/home'); // For simplicity, navigate if token exists
    } else {
      Get.offAllNamed('/login');
    }
  }
}