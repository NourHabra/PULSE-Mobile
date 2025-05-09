import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../models/doctor_model_featured_homepage.dart'; // Import your FeaturedDoctor model
import '../../theme/app_light_mode_colors.dart'; // Import your color theme

class DoctorCard extends StatelessWidget {
  final FeaturedDoctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container( // Use a Container for more customization
      decoration: BoxDecoration(
        color: Colors.transparent, // Make the background transparent
        border: Border.all(
          color: Color(0xFFE8F3F1), // Set the border color
          width: 1.3, // You can adjust the border width
        ),
        borderRadius: BorderRadius.circular(15.0), // Optional: Add rounded corners to the container
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 6), // Set the internal padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image on the Left
            SizedBox(
              width: 121,
              height: 121,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Optional: rounded corners
                child: Image.network(
                  doctor.pictureUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person), // Fallback icon
                ),
              ),
            ),
            const SizedBox(width: 20), // Spacing between image and text

            // Column for Name, Specialization, and Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Important to avoid vertical overflow
                children: [
                  SizedBox(height: 6,),
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
                      const Icon(FeatherIcons.mapPin, size: 13, color: AppLightModeColors.blueText),
                      const SizedBox(width: 4),
                      Text(
                        doctor.coordinates != null
                            ? 'Near you' // Replace with actual location display if needed
                            : 'Location unavailable',
                        style: const TextStyle(fontSize: 14,color:AppLightModeColors.blueText),
                      ),

                    ],
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}