import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

class EmergencyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;

  const EmergencyButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon = Icons.local_shipping,
    this.textColor = AppLightModeColors.icons,
    this.iconColor = Colors.redAccent,
    this.borderColor = Colors.redAccent,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor ?? Colors.transparent, width: 1.7),
            boxShadow: [
              BoxShadow(
                color: AppLightModeColors.textFieldBorder,
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Ensure row takes minimum space
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: iconColor,
                  size: 45,
                ),
              const SizedBox(width: 10),
              // Added Flexible and TextOverflow for responsiveness
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis, // Truncate long text with "..."
                  maxLines: 1, // Ensure text stays on a single line
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
