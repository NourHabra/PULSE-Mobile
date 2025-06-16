import 'package:flutter/material.dart';

import '../theme/app_light_mode_colors.dart';

class CustomListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomListItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18.0,color:AppLightModeColors.normalText),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}