import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/screens/medical_record_screens/pdf_reader_for_test_screen.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/medical_record/labResult_controller.dart';
import '../../theme/app_light_mode_colors.dart';

class LabResultDetailsScreen extends StatelessWidget {
  const LabResultDetailsScreen({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    final LabResultDetailsController controller = Get.find();

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Result Details'),
      // Changed app bar title
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
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
                    style: const TextStyle(color:  AppLightModeColors.normalText, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => controller.refreshLabResultDetails(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppLightModeColors.mainColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (controller.labResultDetails.value == null) {
            return const Center(child: Text('No lab result details found.'));
          } else {
            final details = controller.labResultDetails.value!;
            return RefreshIndicator(
              onRefresh: () => controller.refreshLabResultDetails(),
              color: AppLightModeColors.mainColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0), // Adjusted padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header Section (Image, Test Name, Date, Type, Lab) ---
                    _buildHeaderSection(
                      context,
                      testName: details.test?.name ?? 'N/A',
                      date: details.medicalRecordEntry?.formattedDate ?? 'N/A',
                      testType: details.test?.type ?? 'N/A',
                      laboratoryName: details.laboratory?.name ?? 'N/A',
                    ),
                    const SizedBox(height: 30),

                    // --- Test Description Section ---
                    if (details.test?.description != null &&
                        details.test!.description!.isNotEmpty)
                      _buildSectionHeader('Test Description'),
                    if (details.test?.description != null &&
                        details.test!.description!.isNotEmpty)
                      _buildBodyText(details.test!.description!),

                    if (details.test?.normalValues != null &&
                        details.test!.normalValues!.isNotEmpty)
                      const SizedBox(height: 10),
                    // Spacing between description and normal values
                    if (details.test?.normalValues != null &&
                        details.test!.normalValues!.isNotEmpty)
                      _buildBodyText(
                          'Normal Values: ${details.test!.normalValues!}'),

                    const SizedBox(height: 20),

                    // --- Technician Section ---
                    if (details.technician != null &&
                        details.technician!.fullName.isNotEmpty)
                      _buildSectionHeader('Technician'),
                    if (details.technician != null &&
                        details.technician!.fullName.isNotEmpty)
                      _buildBodyText(details.technician!.fullName),

                    const SizedBox(height: 20),

                    // --- Notes Section ---
                    if (details.technicianNotes != null &&
                        details.technicianNotes!.isNotEmpty)
                      _buildSectionHeader('Notes'),
                    if (details.technicianNotes != null &&
                        details.technicianNotes!.isNotEmpty)
                      _buildBodyText(details.technicianNotes!),

                    const SizedBox(height: 20),

                    // --- Attachments Section ---
                    if (details.resultsAttachment != null &&
                        details.resultsAttachment!.isNotEmpty)
                      _buildSectionHeader('Attachments'),
                    if (details.resultsAttachment != null &&
                        details.resultsAttachment!.isNotEmpty)
                      _buildAttachmentCard(
                          attachmentUrl: details.resultsAttachment!),
                  ],
                ),
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  // --- New Header Section Widget ---
  Widget _buildHeaderSection(BuildContext context, {
    required String testName,
    required String date,
    required String testType,
    required String laboratoryName,
  }) {
    return Container(

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              border: Border.all(

                color: AppLightModeColors.textFieldBorder,
                width: 1.0,
              ),
              // Light blue background for the image
              borderRadius: BorderRadius.circular(
                  12), // Rounded corners for the container
            ),
            padding: const EdgeInsets.all(10),
            // Padding inside the container for the image
            child: Image.asset(
              'assets/lab.jpg', // Your asset image
              fit: BoxFit.cover, // Adjust as needed
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  testName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:  AppLightModeColors.normalText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppLightModeColors.blueText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  testType,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppLightModeColors.blueText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  laboratoryName,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppLightModeColors.blueText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppLightModeColors.normalText,
        ),
      ),
    );
  }

  // Helper for body text (like description, notes, technician name)
  Widget _buildBodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: AppLightModeColors.icons,
        ),
      ),
    );
  }


  Widget _buildAttachmentCard({required String attachmentUrl}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: AppLightModeColors.textFieldBorder,
          width: 1.5,
        ),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          // Changed navigation to the new in-app PDF viewer
          Get.to(
                () => PdfViewerScreen(
              pdfUrl: attachmentUrl,
              title: 'Lab Results (PDF)', // You can customize the title here
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [

              Expanded(
                child: Text(
                  'View Lab Results (PDF)',
                  style: TextStyle(
                    fontSize: 18,

                    color: AppLightModeColors.icons,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppLightModeColors.icons, size: 24), // Add an arrow icon
            ],
          ),
        ),
      ),
    );
  }
}