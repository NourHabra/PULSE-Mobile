import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

class SocialSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Image icon;
  final String label;
  final EdgeInsets? iconPadding; // New parameter for icon padding

  const SocialSignInButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.iconPadding, // Make the padding optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            side: BorderSide(color: AppLightModeColors.textFieldBorder, width: 1.5),
          ),
          child: Row(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: iconPadding ?? EdgeInsets.zero, // Use provided padding or default to zero
                  child: SizedBox(
                    child: icon,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 24.0), // Add some spacing on the right to balance
            ],
          ),
        ),
      ),
    );
  }
}