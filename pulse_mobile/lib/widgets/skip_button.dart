import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import '../../widgets/splash_arrow_forward_button.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  SkipButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, // Use the passed onPressed callback
      child: Text(
        'Skip',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}