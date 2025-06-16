import 'package:get/get.dart';

import 'package:pulse_mobile/screens/home_screens/home_screen1.dart';
import 'package:pulse_mobile/screens/login_screens/login.dart';
import 'package:pulse_mobile/screens/login_screens/forgot.dart';
import 'package:pulse_mobile/screens/login_screens/varification.dart';
import 'package:pulse_mobile/screens/signup_screens/signup1_screen.dart';
import 'package:pulse_mobile/screens/signup_screens/signup2_screen.dart';
import 'package:pulse_mobile/screens/signup_screens/signup3_screen.dart';
import 'package:pulse_mobile/screens/medical_record_screens/medicalRecordList_screen.dart';
import 'package:pulse_mobile/screens/notification_screens/notification_screen1.dart';
import 'package:pulse_mobile/screens/profile_screens/profile_screen1.dart';
import 'package:pulse_mobile/screens/doctor_screens/doctor_details_screen.dart';
import 'package:pulse_mobile/screens/doctor_screens/first_doctor_screen.dart';
import 'package:pulse_mobile/screens/emergencyEvents_screens/emergencyEvent_screen.dart';
import 'package:pulse_mobile/screens/lab_screens/LabDetailsScreen.dart';
import 'package:pulse_mobile/screens/lab_screens/allTestsForLabScreen.dart';
import 'package:pulse_mobile/screens/medicalDrug_screens/currentMedications_screen.dart';
import 'package:pulse_mobile/screens/medicalDrug_screens/prescriptionList_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/changePassword_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/editProfile_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/mysaved_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/settings_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/medicationsAndPrescriptions_screen.dart';
import 'package:pulse_mobile/screens/profile_screens/mySavedDeatils_screen.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen1.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen2.dart';
import 'package:pulse_mobile/screens/splash_screens/splash_screen3.dart';
import 'package:pulse_mobile/screens/medicalDrug_screens/prescription_details_screen.dart'; // Ensure this points to your *actual* PrescriptionDetailsPage widget
// Import ALL your bindings
import 'package:pulse_mobile/controllers/login/forgotPassword_binder.dart';
import 'package:pulse_mobile/controllers/login/login_binder.dart';
import 'package:pulse_mobile/controllers/signup/signup_binding.dart';
import 'package:pulse_mobile/controllers/emergencyEvents/emergency_event_binder.dart';
import 'package:pulse_mobile/controllers/Labs/allTestsForLab_binder.dart';
import 'package:pulse_mobile/controllers/profile/changePassword_binder.dart';
import 'package:pulse_mobile/controllers/profile/mySavedDetailsBinder.dart';

import '../controllers/login/loginredirect.dart';
import '../controllers/login/resetPassword_binding.dart';
import '../controllers/login/two_factor_binding.dart';
import '../controllers/login/varification_binder.dart';
import '../controllers/medications/prescription_Details_binder.dart'; // Your PrescriptionDetailsBinding
import '../controllers/profile/allergies_binder.dart';
import '../controllers/profile/conditions.binder.dart';
import '../screens/login_screens/resetPassword_screen.dart';
import '../screens/login_screens/two_factor_screen.dart';
import '../screens/profile_screens/allergies_screens.dart';
import '../screens/profile_screens/conditions.dart'; // Your ResetNewPasswordScreen


class AppPages {
  static final List<GetPage> pages = [
    // Splash Routes
    GetPage(name: '/splash1', page: () => Splash1()),
    GetPage(name: '/splash2', page: () => Splash2()),
    GetPage(name: '/splash3', page: () => Splash3()),

    GetPage(name: '/login_redirect', page: () => const LoginRedirectScreen()),

    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/two-factor', // This matches the Get.offNamed('/two-factor') call
      page: () => const TwoFactorScreen(), // The UI screen for 2FA
      binding: TwoFactorBinding(), // The binding for the 2FA controller
    ),
    GetPage(
      name: '/forgot',

      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: '/verification',
      page: () => const VerificationScreen(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: '/reset-new-password',
      page: () => const ResetNewPasswordScreen(),
      binding: ResetNewPasswordBinding(),
    ),
    GetPage(
      name: '/signup1',
      page: () => SignUpPage1(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: '/signup2',
      page: () => SignUpPage2(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: '/signup3',
      page: () => const SignUpPage3(),
      binding: SignUpBinding(),
    ),

    // Home Routes (Only one definition for /home1)
    GetPage(name: '/home1', page: () => HomeScreen1()),
    GetPage(name: '/emergency_events', page: () => const EmergencyEventsScreen(), binding: EmergencyEventsBinding()),


    // Bottom Bar Routes (screens accessible from a bottom navigation bar, if applicable)
    GetPage(name: '/notification1', page: () => NotificationScreen1()),

    GetPage(name: '/profile1', page: () => ProfileScreen1()),
    GetPage(name: '/record1', page: () => MedicalRecordListScreen()),

    // Doctor Routes
    GetPage(name: '/doctor1', page: () => FirstDoctorScreen()),
    GetPage(name: '/doctordetails', page: () => DoctorDetailsScreen()),

    // Lab Routes
    GetPage(name: '/labdetails', page: () => LabDetailsScreen()),
    GetPage(name: '/alltestsforlab', page: () => AllTestsForLabScreen(), binding: AllTestsForLabBinding()),

    // Medications & Prescriptions Routes
    GetPage(name: '/currentMedications', page: () => CurrentMedicationsScreen()),
    GetPage(name: '/prescriptionHistory', page: () => PrescriptionsScreen()),
    GetPage(
      name: '/prescription-details',
      page: () => const PrescriptionDetailsPage(), // Ensure 'const' if the constructor is const
      binding: PrescriptionDetailsBinding(),
    ),
    // New: Conditions Route
    GetPage(
      name: '/conditions', // The named route for the Conditions screen
      page: () => const ConditionsScreen(), // The ConditionsScreen widget
      binding: ConditionsBinding(), // The binding for the ConditionsController
    ),
    GetPage(
      name: '/allergies', // The named route for the Allergies screen
      page: () => const AllergiesScreen(), // The AllergiesScreen widget
      binding: AllergiesBinding(), // The binding for the AllergiesController
    ),

    // Profile Routes
    GetPage(name: '/saved', page: () => MySavedPage()),
    GetPage(name: '/settings', page: () => SettingsPage()),
    GetPage(name: '/med&pres', page: () => MedicationsAndPrescriptionsPage()),
    GetPage(name: '/changepassword', page: () => const ChangePasswordPage(), binding: ChangePasswordBinding()),
    GetPage(name: '/editProfile', page: () => EditProfileScreen()),
    GetPage(name: '/savedDetails', page: () => MySavedDetailsPage(), binding: MySavedDetailsBinding()),
  ];
}


// <--- REMOVE THIS INCORRECT DUPLICATE CLASS DEFINITION
// class PrescriptionDetailsPage {
//   const PrescriptionDetailsPage();
// }
