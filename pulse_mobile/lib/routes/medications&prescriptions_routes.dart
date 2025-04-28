import 'package:get/get.dart';
import 'package:pulse_mobile/screens/medicalDrug_screens/currentMedications_screen.dart';
import 'package:pulse_mobile/screens/medicalDrug_screens/prescriptionList_screen.dart';



List<GetPage> getPages = [
  GetPage(name: '/currentMedications', page: () => CurrentMedicationsScreen()),
  GetPage(name: '/prescriptionHistory', page: () => PrescriptionsScreen()),


];