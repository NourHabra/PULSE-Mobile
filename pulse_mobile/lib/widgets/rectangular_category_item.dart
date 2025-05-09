import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:string_2_icon/string_2_icon.dart';

import '../../models/categoryModel.dart';
import '../../theme/app_light_mode_colors.dart';

class RectangularCategoryItem extends StatelessWidget {
  final Category category;
  final Function onTap;

  const RectangularCategoryItem({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder( // Define border and radius here
          side: BorderSide(color: AppLightModeColors.textFieldBorder, width: 1.0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(15), // Keep borderRadius for InkWell
          child: Container(
            width: Get.width, // Take the full screen width
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 30),
            child: Row(
              children: [
                _buildImage(), // Image on the left
                const SizedBox(width: 20), // Spacing between image and title
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final String? imageUrl = category.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(
        Icons.image_not_supported,
        color: AppLightModeColors.icons,
        size: 60, // Match the Image.network size
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.error,
            color: AppLightModeColors.icons,
            size: 60,
          );
        },
      );
    } else if (imageUrl.contains('assets/')) {
      return Image.asset(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      );
    } else {
      try {
        return Icon(
          String2Icon.getIconDataFromString(imageUrl),
          color: AppLightModeColors.icons,
          size: 60,
        );
      } catch (e) {
        print("Error: Invalid icon string: $imageUrl. Error: $e");
        return Icon(
          Icons.error,
          color: AppLightModeColors.icons,
          size: 60,
        );
      }
    }
  }
}