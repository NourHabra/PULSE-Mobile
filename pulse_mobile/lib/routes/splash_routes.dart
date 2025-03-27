import 'package:get/get.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen1.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen2.dart';
import '../screens/splash_screens/splash_screen3.dart';
import '../screens/splash_screens/splash_screen4.dart';
import '../screens/splash_screens/splash_screen5.dart';


List<GetPage> getPages = [
  GetPage(name: '/splash1', page: () => Splash1()),
  GetPage(name: '/splash2', page: () => Splash2()),
  GetPage(name: '/splash3', page: () => Splash3()),
  GetPage(name: '/splash4', page: () => Splash4()),
  GetPage(name: '/splash5', page: () => Splash5()),
  // Add other routes
];