import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_light_mode_colors.dart';

class CircularDoctorWidget extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String name; // Added name parameter
  final double radius;
  final VoidCallback? onTap;

  const CircularDoctorWidget({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.name, // Make name a required parameter
    this.radius = 60.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String displayName = name;
    if (name.length > 10) {
      displayName = '${name.substring(0, 11)}\n${name.substring(10)}';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: AppLightModeColors.textFieldBorder,
                    blurRadius: 0.5,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image.network(
                  imageUrl,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person_outline,
                      color: AppLightModeColors.icons,
                      size: radius,
                    );
                  },
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppLightModeColors.mainColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16.0,
            color:Colors.black,
          ),
        ),
      ],
    );
  }
}