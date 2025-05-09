import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:string_2_icon/string_2_icon.dart';
import '../../models/categoryModel.dart';
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
    print('SquareCategoryItem - imageKey: $imageKey, title: $title, data: $data'); // Add this
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
                      padding: const EdgeInsets.all(15.0),
                      child: _buildImageOrIcon(), // Method in this class
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,

              color: AppLightModeColors.icons,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
  Widget _buildImageOrIcon() {
    String? imageUrl;
    if (imageKey == 'url') {
      imageUrl = (data as Category).imageUrl;
    } else {
      imageUrl = null;
    }
    print('hi from build image or icon');
    print('_buildImageOrIcon - imageUrl: $imageUrl'); // Add this line


    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(
        Icons.image_not_supported,
        color: AppLightModeColors.icons,
        size: 50,
      );
    }

    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: Get.width / 10,
        height: Get.width / 10.4,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.error,
            color: AppLightModeColors.icons,
            size: 50,
          );
        },
      );
    } else if (imageUrl.contains('assets/')) {
      return Image.asset(
        imageUrl,
        width: Get.width / 10,
        height: Get.width / 10.4,
        fit: BoxFit.contain,
      );
    } else {
      try {
        return Icon(
          String2Icon.getIconDataFromString(imageUrl),
          color: AppLightModeColors.icons,
          size: Get.width / 8,
        );
      } catch (e) {
        print("Error: Invalid icon string: $imageUrl. Error: $e");
        return const Icon(
          Icons.error,
          color: AppLightModeColors.icons,
          size: 50,
        );
      }
    }
  }
}