import 'package:get/get.dart';
import 'package:pulse_mobile/screens/doctor_screens/doctor_details_screen.dart';
import 'package:pulse_mobile/screens/doctor_screens/first_doctor_screen.dart';



List<GetPage> getPages = [
  GetPage(name: '/doctor1', page: () => FirstDoctorScreen()),
  GetPage(name: '/doctordetails', page: () => DoctorDetailsScreen()), // Correct route name
];