import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/routes/splash_routes.dart';

import '../../theme/app_light_mode_colors.dart';
import '../../widgets/skip_button.dart';
import '../../widgets/splash_arrow_forward_button.dart';
class Splash4 extends StatefulWidget {
  @override
  _Splash4State createState() => _Splash4State();
}

class _Splash4State extends State<Splash4> {
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (!_buttonPressed) {
        Get.offNamed('/splash5');
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
                'assets/doctor3.png', // Replace with your image path
                width: 400, // Adjust width as needed
                height: 450, // Adjust height as needed
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
                      padding: const EdgeInsets.only(top:10,bottom: 10,right: 65),
                      child: Text(
                        "Find alot of specialist doctors in one place",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
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
                        SizedBox(width: 200),
                        ArrowForwardButton(
                          onPressed: () {
                            _buttonPressed = true;
                            Get.offNamed('/splash5');
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