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

      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}