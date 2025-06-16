import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import '../../controllers/login/varification_controller.dart';
import '../../widgets/appbar.dart'; // Ensure CustomAppBar is defined here or provide its code

class VerificationScreen extends GetView<VerificationController> {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listener for informational messages only
    // Errors will NOT be shown on screen, they will be printed to the terminal.
    ever(controller.infoMessage, (String? message) {
      if (message != null && message.isNotEmpty) {
        Get.snackbar(
          'Info', // Title for informational messages
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8), // Green for info
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        controller.infoMessage.value = ''; // Clear the message after showing
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        titleText: '',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
              'Enter code that we have sent to your ${controller.isEmail ? 'email' : 'number'} ${controller.maskedContact}',
              style:
              const TextStyle(fontSize: 19, color: AppLightModeColors.icons),
              textAlign: TextAlign.left,
            )),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                controller.codeControllers.length,
                    (index) => Container(
                  width: 55,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppLightModeColors.mainColor, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: TextField(
                      controller: controller.codeControllers[index],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        controller.onCodeChanged(value, index, context);
                      },
                      style: const TextStyle(fontSize: 26.0),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.proceedToPasswordReset,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                backgroundColor: AppLightModeColors.mainColor,
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              )
                  : const Text(
                'Verify',
                style:
                TextStyle(fontSize: 19.0, color: Colors.white,fontWeight: FontWeight.w600),
              ),
            )),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}