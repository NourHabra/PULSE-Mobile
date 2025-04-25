import 'package:get/get.dart';
import 'package:pulse_mobile/screens/profile_screens/changePassword_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/editProfile_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/mysaved_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/settings_screen.dart';
import '../controllers/profile/changePassword_binder.dart';
import '../screens/profile_screens/medicationsAndPrescriptions_screen.dart';


List<GetPage> getPages = [
  GetPage(name: '/saved', page: () => MySavedPage()),
  GetPage(name: '/settings', page: () => SettingsPage()),
  GetPage(name: '/med&pres', page: () => MedicationsAndPrescriptionsPage()),

  GetPage(
    name: '/changepassword',
    page: () => const ChangePasswordPage(),
    binding: ChangePasswordBinding(), //  binding here
  ),
  GetPage(name: '/editProfile', page: () => EditProfileScreen()),

];