import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../theme/app_light_mode_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback? onLeadingPressed;
  final Widget? leadingIcon;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.titleText,
    this.onLeadingPressed,
    this.leadingIcon,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 10,bottom: 2),
      child: AppBar(
        backgroundColor:
        Colors.transparent, // Set the background color to transparent
        leading: IconButton(
          icon: leadingIcon ?? const Icon(FeatherIcons.chevronLeft, size: 32,),
          onPressed: onLeadingPressed ?? () => Get.back(),
        ),
        title: Text(
          titleText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppLightModeColors.normalText
          ),
        ),
        centerTitle: true,
        actions: actions != null
            ? actions!.map((action) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: action,
        )).toList()
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

