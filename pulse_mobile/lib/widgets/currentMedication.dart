import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart'; // Import your color

class Currentmedication extends StatelessWidget {
  final String tradeName;
  final String pharmaComposition;
  final String numOfTimes;
  final String untilDate;

  const Currentmedication({
    super.key,
    required this.tradeName,
    required this.pharmaComposition,
    required this.numOfTimes,
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
        padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 18), // Add padding inside the container
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them out
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the left
              children: [
                Text(
                  tradeName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  pharmaComposition,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppLightModeColors.blueText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  numOfTimes,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppLightModeColors.blueText,
                  ),
                ),
              ],
            ),
            Row( // Use a Row to combine "Until: " and untilDate
              children: [
                const Text(
                  "Until ",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppLightModeColors.blueText,
                    // You might want it bold
                  ),
                ),
                Text(
                  untilDate,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppLightModeColors.blueText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

