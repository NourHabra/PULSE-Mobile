import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/categoryModel.dart';
import '../theme/app_light_mode_colors.dart';

class CategoryList extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryList({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container( // Changed from Card to Container
        decoration: BoxDecoration(
          color: Colors.transparent, // Set background to transparent
          border: Border.all(color: AppLightModeColors.textFieldBorder , width: 1.5), // Add a gray border
          borderRadius: BorderRadius.circular(15), // Keep the border radius
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 27.0, horizontal: 25),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold,color: AppLightModeColors.normalText),
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