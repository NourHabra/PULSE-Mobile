import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart'; // Import your color
import 'package:intl/intl.dart'; // Import for DateFormat

class Currentmedication extends StatelessWidget {
  final String name;
  final String activeSubstance;
  final String dosage;
  final String duration; // e.g., "11 days"
  final String prescribedDate; // e.g., "30/04/2025"

  const Currentmedication({
    super.key,
    required this.name,
    required this.activeSubstance,
    required this.dosage,
    required this.duration,
    required this.prescribedDate,
  });

  // Helper method to calculate the 'until date'
  String _calculateUntilDate() {
    try {
      // 1. Parse the prescribedDate string into a DateTime object
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final DateTime startDate = formatter.parse(prescribedDate);

      // 2. Extract the number of days from the duration string (e.g., "11 days")
      final RegExp regExp = RegExp(r'\d+'); // Regular expression to find one or more digits
      final Match? match = regExp.firstMatch(duration);
      int daysToAdd = 0;
      if (match != null) {
        daysToAdd = int.tryParse(match.group(0)!) ?? 0;
      }

      // 3. Add the duration to the start date
      final DateTime endDate = startDate.add(Duration(days: daysToAdd));

      // 4. Format the end date back into 'dd/MM/yyyy' string
      return formatter.format(endDate);
    } catch (e) {
      print('Error calculating until date: $e');
      return 'N/A'; // Return N/A or handle error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the until date here
    final String untilDate = _calculateUntilDate();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppLightModeColors.textFieldBorder,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    activeSubstance,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppLightModeColors.blueText,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dosage,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppLightModeColors.blueText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Until", // Changed "Take For" to "Until"
                  style: TextStyle(
                    fontSize: 16,
                    color: AppLightModeColors.blueText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4,),
                Text(
                  untilDate, // Display the calculated untilDate
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