// lib/widgets/DrugCard.dart
import 'package:flutter/material.dart';

import '../models/prescriptionitem.dart';
import '../theme/app_light_mode_colors.dart'; // Import AppLightModeColors

class DrugCard extends StatelessWidget {
  final PrescriptionLineItem medication; // Now expects a PrescriptionLineItem

  const DrugCard({Key? key, required this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15.0), // Replicated border radius
        border: Border.all(
          color: AppLightModeColors.textFieldBorder,
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drug Name
            Text(
              medication.drug?.name ?? 'Unknown Drug',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold,color: AppLightModeColors.normalText),
            ),
            const SizedBox(height: 5),

            // Row for details (left) and duration (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space evenly
              children: [
                // Left side: Active Substance, Strength, and Dosage
                Expanded( // Ensures this column takes available space and pushes the duration to the right
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${medication.drug?.activeSubstance ?? 'N/A'}, '

                        ,style: const TextStyle(
                            fontSize: 16, color: AppLightModeColors.blueText),
                      ),
                      const SizedBox(height: 4),
                      // Small spacing between lines
                      Text(
                        '${medication.drug?.strength ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 16, color: AppLightModeColors.blueText),
                      ),
                      const SizedBox(height: 4),
                      // Small spacing between lines
                      Text(
                        '${medication.dosage ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 16, color: AppLightModeColors.blueText),
                      ),
                    ],
                  ),
                ),
                // Right side: Take for X Days
                Text(
                  'Take for ${medication.duration ?? 'N/A'}',
                  style: const TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: AppLightModeColors.blueText,fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height:4 ), // Spacing after the details/duration row

            // Notes
            Text(
              'Notes: ${medication.notes ?? 'No specific notes'}',
              style: const TextStyle(
                  fontSize: 16, color: AppLightModeColors.blueText),
            ),
            const SizedBox(height: 5),


          ],
        ),
      ),
    );
  }
}