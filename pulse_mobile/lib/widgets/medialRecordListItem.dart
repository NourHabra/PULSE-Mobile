import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// Ensure these paths are correct
// import '../models/medicalrecordlistitemsModel.dart'; // No longer directly needed if passing specific strings
import '../theme/app_light_mode_colors.dart'; // Make sure this path is correct

class MedicalRecordListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath; // Path to the asset image
  final VoidCallback onTap;

  const MedicalRecordListItem({
    Key? key,
    required this.title,
    required this.subtitle,
    this.imagePath = 'assets/stethoscope_white.png', // Default image
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0), // Apply rounded corners to InkWell splash
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.transparent, // Explicitly set background to transparent
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          border: Border.all(
            color: AppLightModeColors.textFieldBorder, // Border color
            width: 1.0,
          ),
        ),
        child: Column( // This main Column stacks the image/text row and the icon row
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the top
              children: [
                // Left: Image/Icon Container (70x70)
                Container(
                  width: 70.0, // Container size remains 70x70
                  height: 70.0, // Container size remains 70x70
                  decoration: BoxDecoration(
                    color: AppLightModeColors.mainColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  clipBehavior: Clip.antiAlias, // Ensures image respects container's rounded corners
                  child: Center( // Center the smaller image inside
                    child: SizedBox( // Give the image a smaller specific size
                      width: 50.0, // Desired image width
                      height: 50.0, // Desired image height
                      child: Image.asset(
                        imagePath, // Use the provided imagePath
                        fit: BoxFit.contain, // Use contain to ensure the whole image is visible
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0), // Spacing between image and text

                // Middle: Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, // Use the provided title
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: AppLightModeColors.normalText
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),

                      Text(
                        subtitle, // Use the provided subtitle (date or laboratory name)
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppLightModeColors.blueText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ---
            // New Row for the chevron icon, aligned to the bottom right
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Pushes content to the far right
              children: [
                Icon(
                  FeatherIcons.chevronRight,
                  color: AppLightModeColors.icons,
                  size: 20.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}