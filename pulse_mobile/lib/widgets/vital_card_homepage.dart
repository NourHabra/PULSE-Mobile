import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VitalCard extends StatelessWidget {
  final Color? color;
  final String? topText;
  final String? middleMainText;
  final String? middleSubText;
  final String? bottomText;
  final IconData? icon;
  final double? width;
  final double? height;
  final double? borderRadius;

  const VitalCard({
    super.key,
    this.color,
    this.topText,
    this.middleMainText,
    this.middleSubText,
    this.bottomText,
    this.icon,
    this.width = 172,
    this.height = 155,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
                  size: 35,
                ),
              ),
            const SizedBox(height: 8),
            if (topText != null)
              Text(
                topText!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 2),
            if (middleMainText != null || middleSubText != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (middleMainText != null)
                    Transform.translate(
                      offset: const Offset(0, -2), // Changed to -2 to move it up
                      child: Text(
                        middleMainText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  const SizedBox(width: 3),
                  if (middleSubText != null)
                    Transform.translate(
                      offset: const Offset(0,-5),
                      child: Text(
                        middleSubText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                ],
              ),

            if (bottomText != null)
              Transform.translate(
                offset: const Offset(0, -5),
                child: Text(
                  bottomText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
