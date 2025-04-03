import 'package:get/get.dart';
import 'package:pulse_mobile/screens/home_screens/home_screen1.dart';
import 'package:pulse_mobile/screens/medical_record_screens/record_screen1.dart';
import '../screens/notification_screens/notification_screen1.dart';
import '../screens/profile_screens/profile_screen1.dart';
import '../screens/search_screens/search_screen1.dart';


List<GetPage> getPages = [
  GetPage(name: '/home1', page: () => HomeScreen1()),
  GetPage(name: '/notification1', page: () => NotificationScreen1()),
  GetPage(name: '/search1', page: () => SearchScreen1()),
  GetPage(name: '/profile1', page: () => ProfileScreen1()),
  GetPage(name: '/record1', page: () => RecordScreen1()),
  // Add other routes
];