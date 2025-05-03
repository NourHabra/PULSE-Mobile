import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:string_2_icon/string_2_icon.dart';

class SquareCategoryItem extends StatelessWidget {
  final dynamic data;
  final Function onTap;
  final String iconKey;
  final String title;

  const SquareCategoryItem({
    required this.data,
    required this.onTap,
    required this.iconKey,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          splashColor: Colors.grey,
          borderRadius: BorderRadius.circular(15), // Set border radius
          child: Container( // Use a Container to enforce square shape
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15), // Match InkWell border radius
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0), // Adjust padding for icon
                  child: Icon(
                    String2Icon.getIconDataFromString(data[iconKey].toString()),
                    color: Colors.blue[400],
                    size: Get.width / 6, // Adjust size for square
                  ),
                ),
                const SizedBox(height: 8), // Reduced spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0, // Adjusted font size
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Allow for two lines of text
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