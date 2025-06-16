// lib/widgets/detail_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../theme/app_light_mode_colors.dart'; // Adjust path as needed

class DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const DetailCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Only build the card if the content is not null and not empty
    if (content.trim().isEmpty) {
      return const SizedBox.shrink(); // Return an empty widget if content is empty
    }

    return Container( // Changed from Card to Container
      margin: EdgeInsets.zero, // Remove default card margin, apply to Container
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 25), // Add padding directly to Container
      decoration: BoxDecoration(

        color: Colors.transparent, // Set background to transparent
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppLightModeColors.textFieldBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppLightModeColors.mainColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppLightModeColors.normalText
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15), // Space between title and content
          Text(
            content,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}