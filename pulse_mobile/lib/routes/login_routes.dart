import 'package:get/get.dart';
import 'package:pulse_mobile/screens/home_screens/home_screen1.dart';
import 'package:pulse_mobile/screens/login_screens/login.dart';
import '../controllers/login/forgotPassword_binder.dart';
import '../controllers/login/login_binder.dart';
import '../controllers/signup/signup_binding.dart';
import '../screens/login_screens/forgot.dart';
import '../screens/login_screens/varification.dart';
import '../screens/signup_screens/signup1_screen.dart';
import '../screens/signup_screens/signup2_screen.dart'; // Import the binding

List<GetPage> getPages = [
  GetPage(name: '/home1', page: () => HomeScreen1()),
  GetPage(
    name: '/login',
    page: () => const LoginPage(), // Use const for stateless widgets
    binding: LoginBinding(), // <-- **THIS IS THE CRITICAL FIX for LoginController**
  ),
  GetPage(
    name: '/forgot',
    page: () => const ForgotPasswordScreen(),
    binding: ForgotPasswordBinding(),
  ),
  GetPage(
    name: '/var',
    page: () => const VerificationScreen(), // Use const here if stateless
    // Note: If VerificationScreen needs a controller, add its binding.
  ),
  GetPage(
    name: '/signup1',
    page: () => SignUpPage1(), // Assuming SignUpPage1 is stateful or uses a controller from its binding
    binding: SignUpBinding(), // Ensures SignUpController is bound here
  ),
  GetPage(
    name: '/signup2',
    page: () => SignUpPage2(), // Assuming SignUpPage2 also uses SignUpController
    binding: SignUpBinding(), // Reuse the same binding for multi-step forms
    // IMPORTANT: GetX usually keeps the controller alive across Get.toNamed() if the binding is the same.
    // If you want a *new* SignUpController for signup2, you'd need a different binding type or logic.
    // But for a multi-step form, sharing the same controller is usually desired.
  ),

];

