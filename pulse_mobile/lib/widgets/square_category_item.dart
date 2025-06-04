import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:string_2_icon/string_2_icon.dart';
import '../../models/categoryModel.dart'; // Import your Category model
import '../../theme/app_light_mode_colors.dart';

class SquareCategoryItem extends StatelessWidget {
  final dynamic data;
  final Function onTap;
  final String imageKey;
  final String title;

  const SquareCategoryItem({
    super.key,
    required this.data,
    required this.onTap,
    required this.imageKey,
    required this.title,
  });


  @override
  Widget build(BuildContext context) {
    print('hi from square category item');
    print('SquareCategoryItem - imageKey: $imageKey, title: $title, data: $data');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(),
              splashColor: Colors.grey,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: Get.width / 6,
                height: Get.width / 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: AppLightModeColors.textFieldBorder,
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: Get.width / 8,
                        height: Get.width / 8,
                        child: _buildImageOrIcon(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: Get.width / 3.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppLightModeColors.icons,
                fontWeight:FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageOrIcon() {
    String? imageUrl;
    if (data is Map<String, String>) {
      // Handle Map<String, String> (for doctor specialization filters)
      imageUrl = data[imageKey];
    } else if (data is Category) {
      // Handle Category object
      if (imageKey == 'url') {
        imageUrl = data.imageUrl;
      } else if (imageKey == 'icon') {
        imageUrl = data.icon;
      }
    }

    print('_buildImageOrIcon - imageUrl: $imageUrl');

    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(
        Icons.image_not_supported,
        color: AppLightModeColors.icons,
        size: 40,
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.error,
            color: AppLightModeColors.icons,
            size: 40,
          );
        },
      );
    } else if (imageUrl.contains('assets/')) {
      print('Loading asset image: $imageUrl');
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      try {
        return Icon(
          String2Icon.getIconDataFromString(imageUrl),
          color: AppLightModeColors.icons,
          size: Get.width / 12,
        );
      } catch (e) {
        print("Error: Invalid icon string: $imageUrl. Error: $e");
        return const Icon(
          Icons.error,
          color: AppLightModeColors.icons,
          size: 40,
        );
      }
    }
  }
}
