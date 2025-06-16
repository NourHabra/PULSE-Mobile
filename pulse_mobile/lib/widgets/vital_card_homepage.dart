import 'package:flutter/material.dart';
class VitalCard extends StatelessWidget {
  final Color? color;
  final String? topText;
  final String? middleMainText;
  final String? middleSubText;
  final String? bottomText;
  final IconData? icon;
  final double? width;
  final double? height; // This can now be null and let content drive height
  final double? borderRadius;

  const VitalCard({
    super.key,
    this.color,
    this.topText,
    this.middleMainText,
    this.middleSubText,
    this.bottomText,
    this.icon,
    this.width ,
    this.height ,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      // Removed fixed height here, let content dictate height
      // height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.blue,
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            const SizedBox(height: 8),
            if (topText != null)
              Text(
                topText!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis, // Added overflow
                maxLines: 1, // Added maxLines
              ),
            const SizedBox(height: 2),
            if (middleMainText != null || middleSubText != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (middleMainText != null)
                    Flexible( // Use Flexible to allow text to shrink
                      child: Transform.translate(
                        offset: const Offset(0, -2),
                        child: Text(
                          middleMainText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis, // Added overflow
                          maxLines: 1, // Added maxLines
                        ),
                      ),
                    ),
                  const SizedBox(width: 3),
                  if (middleSubText != null)
                    Flexible( // Use Flexible
                      child: Transform.translate(
                        offset: const Offset(0,-5),
                        child: Text(
                          middleSubText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis, // Added overflow
                          maxLines: 1, // Added maxLines
                        ),
                      ),
                    ),
                ],
              ),

            if (bottomText != null)
              Transform.translate(
                offset: const Offset(0, -1),
                child: Text(
                  bottomText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis, // Added overflow
                  maxLines: 1, // Added maxLines
                ),
              ),
          ],
        ),
      ),
    );
  }
}
