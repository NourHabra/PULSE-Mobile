import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

class MenuOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRed; // New boolean parameter

  const MenuOption({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isRed = false, // Default value is false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the text and icon color based on the isRed parameter
    final textColor = isRed ? Colors.red : AppLightModeColors.normalText; // Default text color
    final iconColor = isRed ? Colors.red : AppLightModeColors.mainColor;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor, // Use the determined icon color
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: textColor, // Use the determined text color
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
