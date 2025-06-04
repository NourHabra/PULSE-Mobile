import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_light_mode_colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../models/doctor_model_featured_homepage.dart';

class DoctorCard extends StatelessWidget {
  final FeaturedDoctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Use GestureDetector to detect taps
      onTap: () {
        Get.toNamed('/doctordetails', arguments: {'doctorId': doctor.id}); // Correct route name
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
                  child: Image.network(
                    doctor.pictureUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person),
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
                      doctor.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialization,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: AppLightModeColors.blueText,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Icon(FeatherIcons.mapPin,
                            size: 13, color: AppLightModeColors.blueText),
                        const SizedBox(width: 4),
                        Text(
                          doctor.coordinates != null
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

