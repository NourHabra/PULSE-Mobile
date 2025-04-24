import 'package:get/get.dart';
import 'package:pulse_mobile/screens/home_screens/home_screen1.dart';
import 'package:pulse_mobile/screens/login_screens/login.dart';
import '../controllers/login/forgotPassword_binder.dart';
import '../screens/login_screens/forgot.dart';
import '../screens/login_screens/varification.dart'; // Import the binding

List<GetPage> getPages = [
  GetPage(name: '/home1', page: () => HomeScreen1()),
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(
    name: '/forgot',
    page: () => const ForgotPasswordScreen(), // Use const here
    binding: ForgotPasswordBinding(), // Associate the binding!
  ),
  GetPage(
    name: '/var',
    page: () => VerificationScreen(), // Use const here
    //binding: ForgotPasswordBinding(), // Associate the binding!
  ),
  // Add other routes
];
