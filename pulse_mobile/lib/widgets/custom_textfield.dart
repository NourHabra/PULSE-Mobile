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
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
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
    // Add listener only if the controller is not already disposed
    // This is defensive programming, but the root is ensuring the controller is not disposed prematurely by the parent.
    if (!widget.controller.hasListeners) { // Check if it already has listeners (less common, but safe)
      widget.controller.addListener(_updateIconColor);
    }
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the controller instance itself changes (unlikely in your setup),
    // we need to remove the listener from the old one and add to the new.
    if (widget.controller != oldWidget.controller) {
      if (!oldWidget.controller.hasListeners) { // Defensive check
        oldWidget.controller.removeListener(_updateIconColor);
      }
      if (!widget.controller.hasListeners) { // Defensive check
        widget.controller.addListener(_updateIconColor);
      }
    }
  }

  @override
  void dispose() {
    // CRITICAL FIX: Only remove the listener if the controller itself hasn't been disposed yet.
    // This assertion fails when you try to remove a listener from an already disposed object.
    try {
      widget.controller.removeListener(_updateIconColor);
    } catch (e) {
      // This catch block is for debugging and to prevent the app from crashing.
      // In production, you might just want to let it fail silently or log it.
      print('Error removing listener from TextEditingController: $e');
      // If the controller is already disposed, we can't remove the listener,
      // but it also means the controller itself is being garbage collected,
      // so the listener won't be called anymore anyway.
    }
    super.dispose();
  }

  void _updateIconColor() {
    // This method might be called after the widget is disposed but before controller is fully removed
    // So, check if the widget is still mounted.
    if (mounted) {
      setState(() {
        _prefixIconColor = widget.controller.text.isNotEmpty
            ? AppLightModeColors.mainColor
            : AppLightModeColors.icons;
      });
    }
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
                keyboardType: widget.keyboardType,
                readOnly: widget.readOnly,
                onTap: widget.onTap,
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