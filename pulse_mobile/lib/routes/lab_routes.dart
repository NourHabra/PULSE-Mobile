import '../controllers/Labs/allTestsForLab_binder.dart';
import '../screens/lab_screens/LabDetailsScreen.dart';
import 'package:get/get.dart';

import '../screens/lab_screens/allTestsForLabScreen.dart';

List<GetPage> getPages = [
  GetPage(name: '/labdetails', page: () => LabDetailsScreen()),
  GetPage(
    name: '/alltestsforlab',
    page: () => AllTestsForLabScreen(),
    binding: AllTestsForLabBinding(), // Add the binding here
  ),
];