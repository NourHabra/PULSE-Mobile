// lib/bindings/login/2fa_binding.dart
import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/login/two_factor.dart';
import '../../services/connections.dart';

class TwoFactorBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Ensure ApiService is correctly found.
    // If ApiService isn't globally available (e.g., via Get.put in main.dart),
    // Get.find() here will return null.
    // A Get.put(ApiService(), permanent: true); in main.dart is HIGHLY recommended.
    Get.lazyPut(() => ApiService()); // This assumes ApiService is already provided by Get.put() or similar.
    // If not, Get.find() will fail.

    // 2. Robustly retrieve arguments.
    bool isEmail = false;
    String emailArg = '';
    final dynamic receivedArgs = Get.arguments;

    print('DEBUG: TwoFactorBinding - Raw Get.arguments: $receivedArgs'); // Add this for debug
    if (receivedArgs != null && receivedArgs is Map<String, dynamic>) {
      isEmail = receivedArgs['isEmail'] ?? false;
      emailArg = receivedArgs['email'] ?? ''; // Expect 'email' key
      print('DEBUG: TwoFactorBinding - Parsed arguments: isEmail=$isEmail, email=$emailArg'); // Add this for debug
    } else {
      print('ERROR: TwoFactorBinding - Get.arguments is NOT a Map<String, dynamic> or is null. Type: ${receivedArgs.runtimeType}');
      // This is where the null issue often arises. If this prints, it's the root cause.
      // You might even consider throwing an exception here if arguments are vital.
      // throw Exception("Failed to receive valid arguments for TwoFactorBinding.");
    }

    // 3. Create the controller with the safely retrieved arguments.
    Get.lazyPut(() => TwoFactorController(
      apiService: Get.find<ApiService>(), // This Get.find() might be failing!
      isEmail: isEmail,
      emailFor2FA: emailArg,
    ));
  }
}