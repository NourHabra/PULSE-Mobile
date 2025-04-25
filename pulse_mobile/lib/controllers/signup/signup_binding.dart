import 'package:pulse_mobile/controllers/signup/signup_controller.dart';
import 'package:get/get.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => SignUpController());
  }
}