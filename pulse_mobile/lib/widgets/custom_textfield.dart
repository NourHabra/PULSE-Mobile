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

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.obscureText = false,
    this.onSuffixIconTap,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Color _prefixIconColor =
      AppLightModeColors.icons; // Default icon color

  @override
  void initState() {
    super.initState();
    // Set initial icon color
    _updateIconColor();
    // Listen for changes in the text field
    widget.controller.addListener(_updateIconColor);
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
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
                child: Icon(widget.prefixIcon,
                    color: _prefixIconColor), // Use the dynamic color
              ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                      color: AppLightModeColors
                          .icons), //keep hint text to default color
                ),
                onChanged: widget.onChanged,
              ),
            ),
            if (widget.suffixIcon != null)
              GestureDetector(
                onTap: widget.onSuffixIconTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                  Icon(widget.suffixIcon, color: AppLightModeColors.icons),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

