import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';

import '../../controllers/qrcode_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/appbar.dart';

class QrScannerScreen extends StatelessWidget {
  // Get.put will create and register the controller if it's not already,
  // or find the existing one.
  final QrScannerController qrController = Get.put(QrScannerController());

  QrScannerScreen({super.key});

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor:  AppLightModeColors.normalText,
      backgroundColor: AppLightModeColors.textFieldBackground, // Background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
        side: BorderSide(
          color: AppLightModeColors.textFieldBorder, // Border color
          width: 1.5, // Border width
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12), // Consistent padding
      elevation: 0, // No shadow by default, matching textfield background
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Scan Doctor Qr'),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                color: AppLightModeColors.normalText, // Background for the scanner view
                child: MobileScanner(
                  controller: qrController.scannerController, // Assign the controller
                  onDetect: qrController.onDetect, // Assign the detection callback
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 15.0,right: 5,left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await qrController.scannerController.toggleTorch();
                    },
                    style: _buttonStyle(), // Apply the common style
                    child: const Text('Toggle Flash'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await qrController.scannerController.switchCamera();
                    },
                    style: _buttonStyle(), // Apply the common style
                    child: const Text('Flip Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      qrController.toggleScanner();
                    },
                    style: _buttonStyle(), // Apply the common style
                    child: Obx(() => Text(
                        qrController.isScannerActive ? 'Stop Scan' : 'Start Scan'
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}