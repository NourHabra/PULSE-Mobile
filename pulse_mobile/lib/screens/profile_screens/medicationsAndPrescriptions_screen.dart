import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/currentMedication.dart';
import '../../widgets/med&presListItem.dart';

class MedicationsAndPrescriptionsPage extends StatelessWidget {
  const MedicationsAndPrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Medications & Prescriptions'),
      body: SingleChildScrollView( // Changed to SingleChildScrollView
        child: Column(
          children: [
            CustomListItem(
              title: 'Current Medications',
              onTap: () {
                Get.toNamed('/currentMedications');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: const Divider( // Moved Divider here
                color: AppLightModeColors.textFieldBorder,
                thickness: 1.0,
              ),
            ),
            CustomListItem(
              title: 'Prescription History',
              onTap: () {
                Get.toNamed('/prescriptionHistory');
              },
            ),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
