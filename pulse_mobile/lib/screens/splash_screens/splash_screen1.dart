import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/routes/splash_routes.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
class Splash1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     //Navigate to Splash2 after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Get.offNamed('/splash2'); // Use offNamed to replace the current route
    });

    return Scaffold(
      backgroundColor: AppLightModeColors.mainColor,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 500,
          height: 500,
        ),
      ),
    );
  }
}