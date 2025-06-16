import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../controllers/medical_record/medicalRecordDetails_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/medicalRecordDetailsCard.dart';

class MedicalRecordDetailsScreen extends StatelessWidget {
  final MedicalRecordDetailsController controller;

  MedicalRecordDetailsScreen({Key? key}) :
        controller = Get.find<MedicalRecordDetailsController>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Record Details'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppLightModeColors.normalText, fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.fetchMedicalRecordDetails(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightModeColors.mainColor,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (controller.medicalRecordDetails.value == null) {
          return const Center(
            child: Text(
              'No medical record details found.',
              style: TextStyle(color: AppLightModeColors.normalText, fontSize: 16),
            ),
          );
        } else {
          final record = controller.medicalRecordDetails.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppLightModeColors.mainColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        FeatherIcons.plusSquare,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color:  AppLightModeColors.normalText,
                          ),
                        ),
                        Text(
                          record.formattedDate,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1, color: AppLightModeColors.textFieldBorder),
                const SizedBox(height: 10),

                Text(
                  'Dr.${record.doctorName}',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color:  AppLightModeColors.normalText,
                  ),
                ),
                Text(
                  record.doctorSpecialty,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),

                // Diagnosis Details
                if (record.officialDiagnosis != null && record.officialDiagnosis!.isNotEmpty)
                  DetailCard( // <--- USING THE NEW WIDGET
                    icon: FeatherIcons.edit,
                    title: 'Diagnosis',
                    content: record.officialDiagnosis!,
                  ),
                if (record.officialDiagnosis != null && record.officialDiagnosis!.isNotEmpty)
                  const SizedBox(height: 15),

                // Diagnosis Follow-ups
                if (record.diagnosisFollowUps != null && record.diagnosisFollowUps!.isNotEmpty)
                  DetailCard( // <--- USING THE NEW WIDGET
                    icon: FeatherIcons.calendar,
                    title: 'Follow-up',
                    content: record.diagnosisFollowUps!,
                  ),
                if (record.diagnosisFollowUps != null && record.diagnosisFollowUps!.isNotEmpty)
                  const SizedBox(height: 15),

                // Emergency Event Notes
                if (record.emergencyNotes != null && record.emergencyNotes!.isNotEmpty)
                  DetailCard( // <--- USING THE NEW WIDGET
                    icon: FeatherIcons.alertTriangle,
                    title: 'Emergency Notes',
                    content: record.emergencyNotes!,
                  ),
                if (record.emergencyNotes != null && record.emergencyNotes!.isNotEmpty)
                  const SizedBox(height: 15),

                // Medical Prescription Notes
                if (record.prescriptionNotes != null && record.prescriptionNotes!.isNotEmpty)
                  DetailCard( // <--- USING THE NEW WIDGET
                    icon: FeatherIcons.fileText,
                    title: 'Medical Prescription',
                    content: record.prescriptionNotes!,
                  ),
                if (record.prescriptionNotes != null && record.prescriptionNotes!.isNotEmpty)
                  const SizedBox(height: 15),

                // Medical Prescription Status
                if (record.prescriptionStatus != null && record.prescriptionStatus!.isNotEmpty)
                  DetailCard( // <--- USING THE NEW WIDGET
                    icon: FeatherIcons.tag,
                    title: 'Prescription Status',
                    content: record.prescriptionStatus!,
                  ),
                if (record.prescriptionStatus != null && record.prescriptionStatus!.isNotEmpty)
                  const SizedBox(height: 15),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}