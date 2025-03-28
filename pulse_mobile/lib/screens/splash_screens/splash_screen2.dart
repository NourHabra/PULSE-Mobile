import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/skip_button.dart';
import '../../widgets/splash_screen_widget.dart';

class Splash2 extends StatefulWidget {
  @override
  _Splash2State createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  bool _buttonPressed = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              SplashContent(
                imageAsset: 'assets/doctor1.png',
                text: 'Keep your health in check!',
                onForwardPressed: () {
                  _buttonPressed = true;
                  if (_currentPage < 2) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                currentPage: _currentPage, // Pass currentPage
              ),
              SplashContent(
                imageAsset: 'assets/doctor2.png',
                text: 'Track your medical record!',
                onForwardPressed: () {
                  _buttonPressed = true;
                  if (_currentPage < 2) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                currentPage: _currentPage, // Pass currentPage
              ),
              SplashContent(
                imageAsset: 'assets/doctor3.png',
                text: 'Find alot of specialist doctors in one place',
                onForwardPressed: () {
                  _buttonPressed = true;
                  Get.offNamed('/splash3');
                },
                currentPage: _currentPage, // Pass currentPage
              ),
            ],
          ),
          // Skip Button
          Positioned(
            top: 30,
            right: 25,
            child: SkipButton(
              onPressed: () {
                Get.offNamed('/splash3');
              },
            ),
          ),
        ],
      ),
    );
  }
}