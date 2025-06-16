import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../models/LabModel.dart';
import '../theme/app_light_mode_colors.dart';
class LabCard extends StatelessWidget {
  final LabModel lab;

  const LabCard({super.key, required this.lab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Added GestureDetector
      onTap: () {
        // Navigate to lab details page, similar to doctor details
        Get.toNamed('/labdetails', arguments: {'labId': lab.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: const Color(0xFFE8F3F1),
            width: 1.3,
          ),

          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 121,
                height: 121,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/lab.jpg', // Replace with your actual asset path
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      lab.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: AppLightModeColors.normalText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lab.address,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: AppLightModeColors.blueText, // Used theme color
                      ),
                    ),
                    const SizedBox(height: 40), // Added spacing
                    Row( // Added location row
                      children: [
                        const Icon(FeatherIcons.mapPin,
                            size: 13, color: AppLightModeColors.blueText),
                        const SizedBox(width: 4),
                        Text(
                          lab.locationCoordinates != null
                              ? 'Near you'
                              : 'Location unavailable',
                          style: const TextStyle(
                              fontSize: 14, color: AppLightModeColors.blueText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}