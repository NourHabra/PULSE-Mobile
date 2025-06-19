// lib/screens/conditions_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import '../../controllers/profile/conditions_controller.dart';
import '../../theme/app_light_mode_colors.dart';

class ConditionsScreen extends StatelessWidget {
  const ConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of ConditionsController
    final ConditionsController controller = Get.put(ConditionsController());

    return Scaffold(
      appBar: const CustomAppBar(titleText: 'My Conditions'),
      body: Obx(() {
        // Display a loading indicator
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }
        // Display an error message
        else if (controller.errorMessage.isNotEmpty && controller.conditions.isEmpty) {
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
        // Display a message if no conditions are found after loading
        else if (controller.conditions.isEmpty) {
          return const Center(
            child: Text(
              'No chronic conditions found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        // Display the list of chronic conditions
        else {
          return ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemCount: controller.conditions.length,
            itemBuilder: (context, index) {
              final condition = controller.conditions[index];

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
                    // Disease Name
                    Text(
                      condition.disease,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: AppLightModeColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Disease Type
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          'Type: ${condition.type}',
                          style: const TextStyle(fontSize: 18, color: AppLightModeColors.normalText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Disease Intensity
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          'Intensity: ${condition.intensity}',
                          style: const TextStyle(fontSize: 18, color: AppLightModeColors.normalText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Start Date
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          'Diagnosed on: ${condition.formattedStartDate}', // Using the getter from the model
                          style: const TextStyle(fontSize: 14, color: AppLightModeColors.normalText),
                        ),
                      ],
                    ),
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
