import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';



class Splash3 extends StatelessWidget {
  const Splash3({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/logo_blue.png',
                width: 200,
                height: 200,
              ),

              Text(
                "Let's get started!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Login to enjoy the features we've provided, and stay healthy!",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 260,
                child: ElevatedButton(
                  onPressed: () {

                    Get.toNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppLightModeColors.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Log in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),

                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 260,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to Sign Up screen
                     Get.toNamed('/signup1');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: BorderSide(color: AppLightModeColors.mainColor), // Match the border color
                  ),
                  child: Text('Sign Up',
                    style: TextStyle(
                      color: AppLightModeColors.mainColor,
                      fontSize: 18,
                    ),),
                ),
              ),

            ],
          ),
        ),
      ),


    );
  }
}