import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/medications/prescription_details_controller.dart';
import 'package:pulse_mobile/widgets/DrugCard.dart';
import 'package:pulse_mobile/widgets/appbar.dart'; // Assuming this provides a CustomAppBar
import 'package:pulse_mobile/widgets/bottombar.dart';
import 'package:pulse_mobile/services/connections.dart'; // Import ApiService to use Get.find<ApiService>()

import '../../models/prescription_details.dart';
import '../../theme/app_light_mode_colors.dart'; // Assuming this provides a CustomBottomNavBar


class PrescriptionDetailsPage extends StatelessWidget {
  const PrescriptionDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Correctly initialize the controller by passing the ApiService instance
    final PrescriptionDetailsController controller = Get.put(PrescriptionDetailsController(apiService: Get.find<ApiService>()));

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Prescription Details'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load prescription details.' ,style: TextStyle(color:  AppLightModeColors.normalText),),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final int? prescriptionId = Get.arguments as int?;
                      if(prescriptionId != null) {
                        controller.fetchPrescriptionDetails(prescriptionId);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (controller.prescription.value == null) {
            return const Center(child: Text('No prescription details available.',style: TextStyle(color:  AppLightModeColors.normalText),));
          } else {
            final PrescriptionDetailsInfo prescription = controller.prescription.value!;
            return SingleChildScrollView( // Use SingleChildScrollView to allow scrolling if content overflows
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
                children: [

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ${prescription.doctor?.fullName ?? 'Unknown Doctor'}',
                        style: const TextStyle(fontSize: 24, color: AppLightModeColors.normalText,fontWeight: FontWeight.bold),
                      ),

                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          prescription.overallFormattedDate ?? 'No Date', // Use the new date field
                          style: const TextStyle(fontSize: 20, color: AppLightModeColors.normalText),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Check and display multiple DrugCards
                  if (prescription.medications != null && prescription.medications!.isNotEmpty)
                    Column( // Use Column to stack multiple DrugCards
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
                      children: [

                        const SizedBox(height: 10),
                        ...prescription.medications!.map((medication) {
                          return DrugCard(medication: medication); // Create a DrugCard for each
                        }).toList(),
                      ],
                    )
                  else
                    const Text('No medication details available for this prescription.',style: TextStyle(color: AppLightModeColors.normalText),),

                  const SizedBox(height: 30),
                  Column(
                    // --- MODIFIED HERE ---
                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                    children: [
                      Text(
                        'Notes: ',
                        style: const TextStyle(fontSize: 20, color: AppLightModeColors.normalText,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10,),
                      Text('${prescription.notes ?? 'No additional notes'}',
                        style: const TextStyle(fontSize: 18, color: AppLightModeColors.normalText),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(), // Assuming CustomBottomNavBar is provided
    );
  }
}