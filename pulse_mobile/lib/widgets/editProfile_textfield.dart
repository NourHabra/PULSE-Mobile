import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

class EditTextField extends StatefulWidget {
  final TextEditingController controller;
  final String suffixText;
  final ValueChanged<String>? onChanged;
  final bool obscureText;

  const EditTextField({
    super.key,
    required this.controller,
    required this.suffixText,
    this.onChanged,
    this.obscureText = false,
  });

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  // Color _suffixTextColor =  AppLightModeColors.mainColor;

  @override
  void initState() {
    super.initState();
    // _updateSuffixTextColor();
    // widget.controller.addListener(_updateSuffixTextColor);
  }

  @override
  void dispose() {
    // widget.controller.removeListener(_updateSuffixTextColor);
    super.dispose();
  }

  // void _updateSuffixTextColor() {
  //   setState(() {
  //     _suffixTextColor = widget.controller.text.isNotEmpty
  //         ? AppLightModeColors.mainColor
  //         : AppLightModeColors.icons;
  //   });
  // }

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
                  color: AppLightModeColors
                      .mainColor, // Made it always mainColor
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

