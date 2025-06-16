// lib/widgets/skip_button.dart
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButton({super.key, required this.onPressed}); // Added const constructor

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, // Use the passed onPressed callback
      child: const Text( // Made Text const
        'Skip',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      style: TextButton.styleFrom(
        // Remove aggressive sizing constraints and add reasonable padding
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Added horizontal/vertical padding
        minimumSize: const Size(60, 30), // Ensured a reasonable minimum tap size
        tapTargetSize: MaterialTapTargetSize.padded, // Use padded for easier tapping
      ),
    );
  }
}