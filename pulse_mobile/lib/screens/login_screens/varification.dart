// lib/pages/verification_code_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import '../../controllers/login/varification_controller.dart';
import '../../widgets/appbar.dart';

class VerificationScreen extends GetView<VerificationController> {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Enter Verification Code',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
              'Enter code that we have sent to your ${controller.isEmail ? 'email' : 'number'} ${controller.maskedContact}',
              style:
              const TextStyle(fontSize: 18, color: AppLightModeColors.icons),
              textAlign: TextAlign.left,
            )),
            const SizedBox(height: 30),
            // Code Input Fields (using CustomTextField)
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                      (index) => Container( // Use a Container for the square input field
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppLightModeColors.mainColor, width: 2.0), // Square border
                      borderRadius: BorderRadius.circular(10.0), // Optional: Rounded corners
                    ),
                    child: Center(
                      child: TextField(
                        controller: controller.codeControllers[index],
                        //hintText: '', // No hint text
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        // Use the default number keyboard
                        onChanged: (value) {
                          controller.onCodeChanged(value, index);
                        },
                        style: const TextStyle(fontSize: 26.0), // Style the text
                        decoration: const InputDecoration( //remove decoration
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.verifyCode,
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
              )
                  : const Text(
                'Verify',
                style:
                TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            )),
            const SizedBox(height: 20),
            TextButton(
              onPressed: controller.resendCode,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16.0), //  default text style
                  children: <TextSpan>[
                    TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyle(
                        color: AppLightModeColors.icons,
                      ),
                    ),
                    TextSpan(
                      text: "Resend",
                      style: TextStyle(
                        color: AppLightModeColors.mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Removed CustomNumberKeyboard
    );
  }
}

