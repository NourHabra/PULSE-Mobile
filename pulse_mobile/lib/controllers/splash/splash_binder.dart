import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}