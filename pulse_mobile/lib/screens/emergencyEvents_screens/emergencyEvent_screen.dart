// lib/views/emergency_events_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import '../../controllers/emergencyEvents/emergencyEvent_controller.dart';
import '../../theme/app_light_mode_colors.dart';
// Make sure to import your model if it's not already imported in the controller

class EmergencyEventsScreen extends StatelessWidget {
  const EmergencyEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmergencyEventsController controller = Get.find<EmergencyEventsController>();

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Emergency Events'),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error: ${controller.errorMessage.value}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else if (controller.emergencyEvents.isEmpty) {
          return const Center(
            child: Text(
              'No emergency events found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemCount: controller.emergencyEvents.length,
            itemBuilder: (context, index) {
              final event = controller.emergencyEvents[index];

              // Safely access patient information
              final String patientFullName = (event.patient != null)
                  ? '${event.patient!.firstName} ${event.patient!.lastName}'
                  : 'N/A';

              // Safely access medical record entry details
              final String eventTitle = (event.medicalRecordEntry != null)
                  ? event.medicalRecordEntry!.title
                  : 'N/A';

              // Safely access timestamp
              final String eventTimestamp = (event.medicalRecordEntry != null)
                  ? event.medicalRecordEntry!.timestamp.toLocal().toIso8601String().substring(0, 16).replaceFirst('T', ' ')
                  : 'N/A';



              return Container( // Changed from Card to Container
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(16.0), // Padding moved inside Container
                decoration: BoxDecoration(
                  color: Colors.transparent, // Transparent background
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppLightModeColors.textFieldBorder, width: 1.5), // Blue border
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventTitle,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: AppLightModeColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 10,),
                        Text('Patient: $patientFullName', style: const TextStyle(fontSize: 18,color: AppLightModeColors.normalText)),
                      ],
                    ),
                    const SizedBox(height: 4),


                    const SizedBox(height: 18),
                    Row(
                      children: [
                        SizedBox(width: 10,),

                        Text(
                          'Date & Time: $eventTimestamp',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    if (event.notes != null && event.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SizedBox(width: 10,),

                          Text('Notes: ${event.notes}', style: const TextStyle(fontSize: 14,color: AppLightModeColors.normalText)),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );

        }
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}