import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

class ArrowForwardButton extends StatelessWidget {
  final VoidCallback onPressed;

  ArrowForwardButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Use the passed onPressed callback
      child: Icon(
        Icons.arrow_forward,
        color: Colors.white,
        size: 25,
      ),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
        backgroundColor: AppLightModeColors.mainColor,
      ),
    );
  }
}