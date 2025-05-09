import 'package:get/get.dart';
import 'package:pulse_mobile/screens/signup_screens/signup1_screen.dart';
import 'package:pulse_mobile/screens/signup_screens/signup2_screen.dart';
import '../controllers/signup/signup_binding.dart';


List<GetPage> getPages = [
  GetPage(
    name: '/signup1',
    page: () => SignUpPage1(),
    binding: SignUpBinding(),
  ),
  GetPage(name: '/signup2', page: () => SignUpPage2()),

  // Add other routes
];