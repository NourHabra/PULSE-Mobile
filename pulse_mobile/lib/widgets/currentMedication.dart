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
          borderRadius: BorderRadius.circular(12.0), // Add border radius for a nice look
        ),
        padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 18), // Add padding inside the container
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
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  pharmaComposition,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppLightModeColors.blueText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2,),
                Row(
                  children: [
                    SizedBox(width: 3,),
                    Text(
                      numOfTimes,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppLightModeColors.blueText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [

                const Text(
                  "Until ",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppLightModeColors.blueText,
                    fontWeight: FontWeight.w600

                  ),
                ),
                Text(
                  untilDate,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppLightModeColors.blueText,
                      fontWeight: FontWeight.w600,
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

