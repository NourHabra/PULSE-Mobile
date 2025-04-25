import 'package:get/get.dart';
import 'package:pulse_mobile/screens/login_screens/login.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen1.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen2.dart';
import '../controllers/signup/signup_binding.dart';
import '../screens/splash_screens/splash_screen3.dart';
import '../controllers/login/login_binder.dart';
import 'package:pulse_mobile/screens/signup_screens/signup1_screen.dart';

List<GetPage> getPages = [
  GetPage(name: '/splash1', page: () => Splash1()),
  GetPage(name: '/splash2', page: () => Splash2()),
  GetPage(name: '/splash3', page: () => Splash3()),
  GetPage(
    name: '/login',
    page: () => const LoginPage(), // Ensure LoginPage is const if possible
    binding: LoginBinding(), // binding
  ),
  GetPage(
    name: '/signup1',
    page: () => SignUpPage1(),
    binding: SignUpBinding(),
  ),

  // Add other routes
];