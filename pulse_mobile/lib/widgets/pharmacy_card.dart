// lib/widgets/pharmacy_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../models/pharmacy.dart';
import '../theme/app_light_mode_colors.dart';

class PharmacyCard extends StatelessWidget {
  final PharmacylistModel pharmacy;

  const PharmacyCard({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    // Removed GestureDetector as the parent PharmacyScreen now handles the tap
    // using InkWell for navigation.
    return Container(
      // Styling for the card container, mimicking the LabCard's appearance.
      decoration: BoxDecoration(
        color: Colors.transparent, // Background color is transparent
        border: Border.all(
          color: const Color(0xFFE8F3F1), // Light border color
          width: 1.3, // Border width
        ),
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image section for the pharmacy card.
            SizedBox(
              width: 121,
              height: 121,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'assets/pill_600dp.png',
                  fit: BoxFit.contain, // Cover the entire space
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error), // Show error icon if image fails
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Take minimum vertical space
                children: [
                  const SizedBox(height: 6),
                  // Pharmacy Name
                  Text(
                    pharmacy.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: AppLightModeColors.normalText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Pharmacy Phone Number (corrected to phone number)
                  Text(
                    pharmacy.phone ?? 'N/A', // Display phone number, with fallback
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: AppLightModeColors.blueText, // Text color from theme
                    ),
                  ),
                  const SizedBox(height: 40), // Spacing
                  Row(
                    children: [
                      const Icon(FeatherIcons.mapPin,
                          size: 13, color: AppLightModeColors.blueText), // Map pin icon
                      const SizedBox(width: 4), // Spacing
                      // Pharmacy Address (corrected to address)
                      Expanded( // Use Expanded to prevent overflow if address is long
                        child: Text(
                          pharmacy.address,
                          style: const TextStyle(
                              fontSize: 14, color: AppLightModeColors.blueText),
                          overflow: TextOverflow.ellipsis, // Add ellipsis for long addresses
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5), // Final spacing at the bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
