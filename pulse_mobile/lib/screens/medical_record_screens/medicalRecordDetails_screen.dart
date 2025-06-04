import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../controllers/medical_record/medicalRecordDetails_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/appbar.dart';

class MedicalRecordDetailsScreen extends StatelessWidget {
  // Use Get.find() to get the controller, it expects the controller to be initialized
  // via Get.put() when navigating to this screen.
  final MedicalRecordDetailsController controller;

  MedicalRecordDetailsScreen({Key? key}) :
        controller = Get.find<MedicalRecordDetailsController>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(titleText: 'Record Details'),
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
                  style: const TextStyle(color: Colors.black, fontSize: 16),
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
              style: TextStyle(color: Colors.black, fontSize: 16),
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
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppLightModeColors.mainColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        FeatherIcons.plusSquare, // A medical-related icon
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                  'Dr.${record.doctorName}', // Assuming Dr. prefix
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  record.doctorSpecialty,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),

                // Symptoms Dropdown
                _buildExpandableCard(
                  icon: FeatherIcons.list,
                  title: 'symptoms',
                  content: record.symptoms ?? 'No symptoms recorded.',
                  isExpanded: false, // Start collapsed
                ),
                const SizedBox(height: 15),

                // Diagnosis Dropdown - This one is expanded by default in the image
                _buildExpandableCard(
                  icon: FeatherIcons.edit,
                  title: 'diagnosis',
                  content: record.diagnosis ?? 'No diagnosis recorded.',
                  isExpanded: true, // Start expanded
                ),
                const SizedBox(height: 15),

                // Medical Prescription Dropdown
                _buildExpandableCard(
                  icon: FeatherIcons.fileText, // or a medical bottle icon
                  title: 'Medical Prescription',
                  content: record.medicalPrescription ?? 'No medical prescription recorded.',
                  isExpanded: false, // Start collapsed
                ),
                const SizedBox(height: 15),

                // Lab Test Dropdown
                _buildExpandableCard(
                  icon: FeatherIcons.clipboard, // or a test tube icon
                  title: 'Lab Test',
                  content: record.labTest ?? 'No lab test recorded.',
                  isExpanded: false, // Start collapsed
                ),
                const SizedBox(height: 15),

                // Notes Dropdown
                _buildExpandableCard(
                  icon: FeatherIcons.bookOpen,
                  title: 'Notes',
                  content: record.notes ?? 'No additional notes.',
                  isExpanded: false, // Start collapsed
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildExpandableCard({
    required IconData icon,
    required String title,
    required String content,
    required bool isExpanded, // Initial expansion state
  }) {
    return Card(
      elevation: 0, // No shadow for a flat look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppLightModeColors.textFieldBorder, width: 1.0),
      ),
      margin: EdgeInsets.zero, // Remove default card margin
      child: Theme( // Use Theme to override InkWell splash color inside ExpansionTile
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent), // Hide divider
        child: ExpansionTile(
          initiallyExpanded: isExpanded, // Set initial expansion state
          leading: Icon(icon, color: AppLightModeColors.mainColor),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: Icon(
            // Use a custom icon that changes based on expansion state if needed,
            // or let ExpansionTile handle its default arrow.
            FeatherIcons.chevronDown,
            color: AppLightModeColors.icons,
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.justify, // Justify the text as in the screenshot
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}