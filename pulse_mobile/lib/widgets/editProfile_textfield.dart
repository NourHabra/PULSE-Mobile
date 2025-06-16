// widgets/editProfile_textfield.dart
import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

class EditTextField extends StatefulWidget {
  final TextEditingController controller;
  final String suffixText;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType keyboardType; // Added keyboardType parameter

  const EditTextField({
    super.key,
    required this.controller,
    required this.suffixText,

    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text, // Default to TextInputType.text
  });

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppLightModeColors.textFieldBackground,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: AppLightModeColors.textFieldBorder,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType, // Pass keyboardType to the inner TextField
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: widget.onChanged,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.suffixText,
                style: const TextStyle(
                  color: AppLightModeColors.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}