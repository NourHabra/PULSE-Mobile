import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart'; // Import your color

class Prescriptionslistitem extends StatelessWidget {
  final String name;
  final String speciality;
  final String untilDate;

  const Prescriptionslistitem({
    super.key,
    required this.name,
    required this.speciality,
    required this.untilDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppLightModeColors.textFieldBorder, // Use your border color
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8.0), // Add border radius for a nice look
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18), // Add padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them out
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the left
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  speciality,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppLightModeColors.blueText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row( // Use a Row to combine "Until: " and untilDate
                  children: [
                    const Text(
                      "Until ",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppLightModeColors.blueText,
                        // You might want it bold
                      ),
                    ),
                    Text(
                      untilDate,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppLightModeColors.blueText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(  // Use an arrow icon here
              FeatherIcons.chevronRight, // You can change to a different arrow if you like
              color: AppLightModeColors.blueText, // Use your color
              size: 24, // Adjust size as needed
            ),
          ],
        ),
      ),
    );
  }
}

