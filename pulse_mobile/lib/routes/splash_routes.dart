import 'package:get/get.dart';
import 'package:pulse_mobile/screens/login_screens/login.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen1.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen2.dart';
import '../screens/splash_screens/splash_screen3.dart';
import '../controllers/login/login_binder.dart';

List<GetPage> getPages = [
  GetPage(name: '/splash1', page: () => Splash1()),
  GetPage(name: '/splash2', page: () => Splash2()),
  GetPage(name: '/splash3', page: () => Splash3()),
  GetPage(
    name: '/login',
    page: () => const LoginPage(), // Ensure LoginPage is const if possible
    binding: LoginBinding(), // binding
  ),
  // Add other routes
];