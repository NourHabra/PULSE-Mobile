import 'package:flutter/material.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import '../../widgets/splash_arrow_forward_button.dart';

class SplashContent extends StatelessWidget {
  final String imageAsset;
  final String text;
  final VoidCallback onForwardPressed;
  final int currentPage; // Add currentPage parameter

  SplashContent({
    required this.imageAsset,
    required this.text,
    required this.onForwardPressed,
    required this.currentPage, // Add currentPage parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Container(
                child: Image.asset(
                  imageAsset,
                  width: 400,
                  height: 450,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF5F7FF),
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 10),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 40),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 15,
                  height: 4,
                  decoration: BoxDecoration(
                    color: currentPage == 0
                        ? AppLightModeColors.mainColor
                        : AppLightModeColors.splashLightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 3),
                Container(
                  width: 15,
                  height: 4,
                  decoration: BoxDecoration(
                    color: currentPage == 1
                        ? AppLightModeColors.mainColor
                        : AppLightModeColors.splashLightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 3),
                Container(
                  width: 15,
                  height: 4,
                  decoration: BoxDecoration(
                    color: currentPage == 2
                        ? AppLightModeColors.mainColor
                        : AppLightModeColors.splashLightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(width: 200),
                ArrowForwardButton(
                  onPressed: onForwardPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}