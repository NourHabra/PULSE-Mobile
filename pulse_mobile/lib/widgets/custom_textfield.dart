import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final TextInputType? keyboardType; // Add keyboardType parameter
  final bool readOnly; // Add readOnly parameter
  final VoidCallback? onTap; // Add onTap parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.keyboardType, // Initialize keyboardType
    this.readOnly = false, // Initialize readOnly with a default value
    this.onTap, // Initialize onTap
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Color _prefixIconColor = AppLightModeColors.icons;

  @override
  void initState() {
    super.initState();
    _updateIconColor();
    widget.controller.addListener(_updateIconColor);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateIconColor);
    super.dispose();
  }

  void _updateIconColor() {
    setState(() {
      _prefixIconColor = widget.controller.text.isNotEmpty
          ? AppLightModeColors.mainColor
          : AppLightModeColors.icons;
    });
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
            if (widget.prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(widget.prefixIcon, color: _prefixIconColor),
              ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType, // Use the passed keyboardType
                readOnly: widget.readOnly, // Use the passed readOnly
                onTap: widget.onTap, // Use the passed onTap
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: AppLightModeColors.icons),
                ),
                onChanged: widget.onChanged,
              ),
            ),
            if (widget.suffixIcon != null)
              GestureDetector(
                onTap: widget.onSuffixIconTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(widget.suffixIcon, color: AppLightModeColors.icons),
                ),
              ),
          ],
        ),
      ),
    );
  }
}