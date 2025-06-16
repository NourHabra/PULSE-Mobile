// lib/screens/allergies_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart'; // Assuming you have a custom bottom nav bar
import '../../controllers/profile/allergies_contorller.dart';
import '../../theme/app_light_mode_colors.dart'; // Assuming your theme is here

class AllergiesScreen extends StatelessWidget {
  const AllergiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of AllergiesController
    final AllergiesController controller = Get.put(AllergiesController());

    return Scaffold(
      appBar: const CustomAppBar(titleText: 'My Allergies'),
      body: Obx(() {
        // Display a loading indicator
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }
        // Display an error message
        else if (controller.errorMessage.isNotEmpty && controller.allergies.isEmpty) {
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
        }
        // Display a message if no allergies are found after loading
        else if (controller.allergies.isEmpty) {
          return const Center(
            child: Text(
              'No known allergies found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        // Display the list of allergies
        else {
          return ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemCount: controller.allergies.length,
            itemBuilder: (context, index) {
              final allergy = controller.allergies[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppLightModeColors.textFieldBorder, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Allergen Name
                    Text(
                      allergy.allergen,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: AppLightModeColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Allergy Type
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          'Type: ${allergy.type}',
                          style: const TextStyle(fontSize: 18, color: AppLightModeColors.normalText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Allergy Intensity
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          'Intensity: ${allergy.intensity}',
                          style: const TextStyle(fontSize: 18, color: AppLightModeColors.normalText),
                        ),
                      ],
                    ),
                    // You can add more fields here if needed from the model
                    // For example, if you want to display patientId or allergyId, uncomment below:
                    // const SizedBox(height: 18),
                    // Row(
                    //   children: [
                    //     const SizedBox(width: 10),
                    //     Text(
                    //       'Patient ID: ${allergy.patientId}',
                    //       style: const TextStyle(fontSize: 14, color: AppLightModeColors.normalText),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            },
          );
        }
      }),
      bottomNavigationBar: CustomBottomNavBar(), // Ensure this widget is correctly defined
    );
  }
}
