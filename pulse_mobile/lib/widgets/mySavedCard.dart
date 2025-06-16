// lib/widgets/mySavedCard.dart

import 'package:flutter/material.dart';
import '../../theme/app_light_mode_colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MySavedCard extends StatelessWidget {
  final String imageUrl; // Can be a network URL or an asset path
  final String name;
  final String description; // For specialization, address, or other details
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap; // NEW: Callback for card tap
  final String type; // e.g., 'doctor', 'laboratory', 'pharmacy'

  const MySavedCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    this.onFavoriteTap,
    this.onTap, // NEW: Include in constructor
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // NEW: Wrap with GestureDetector for tap detection
      onTap: onTap, // Call the new onTap callback
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: const Color(0xFFE8F3F1),
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 6),
          child: SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 131,
                  height: 116,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: imageUrl.startsWith('http')
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80.0, color: Colors.grey),
                    )
                        : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80.0, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: AppLightModeColors.normalText
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: AppLightModeColors.blueText,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.favorite,
                        size: 26, color: AppLightModeColors.blueText),
                    onPressed: onFavoriteTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}