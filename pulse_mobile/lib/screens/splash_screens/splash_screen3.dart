import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/routes/splash_routes.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';

import '../../widgets/skip_button.dart';
import '../../widgets/splash_arrow_forward_button.dart';

class Splash3 extends StatefulWidget {
  @override
  _Splash3State createState() => _Splash3State();
}

class _Splash3State extends State<Splash3> {
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (!_buttonPressed) {
        Get.offNamed('/splash4');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Stack(
        children:[ Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            SizedBox(height: 30,),
            Container(
              child: Image.asset(
                'assets/doctor2.png',
                width: 400,
                height: 450,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF5F7FF), // Top color (#F5F7FF)
                      Colors.white,       // Bottom color (white)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20), // Set the border radius
                ),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                      child: Text(
                        "Track your medical record!",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 15,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppLightModeColors.splash_light_blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(width: 3),
                        Container(
                          width: 15,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppLightModeColors.mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(width: 3),
                        Container(
                          width: 15,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppLightModeColors.splash_light_blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(width: 200),
                        ArrowForwardButton(
                          onPressed: () {
                            _buttonPressed = true;
                            Get.offNamed('/splash4');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 30,)

                  ],
                ),
              ),
            )
          ],
        ),
          Positioned(
            top:30,
            right: 25,
            child: SkipButton(
              onPressed: () {
                Get.offNamed('/splash5');
              },
            ),
          ),
      ]
      ),
    );
  }
}