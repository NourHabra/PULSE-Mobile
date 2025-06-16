// lib/screens/login_screens/two_factor_screen.dart
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import '../../controllers/login/two_factor.dart';
import '../../widgets/appbar.dart';
import 'package:flutter/material.dart';

class TwoFactorScreen extends GetView<TwoFactorController> {
  const TwoFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: '',
      ),
      body: SingleChildScrollView(
        child: Padding(
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

              // Text widget (no Obx needed as its content is static after init)
              Text(
                'Enter code that we have sent to your ${controller.isEmail ? 'email' : 'number'} ${controller.maskedContact}',
                style: const TextStyle(fontSize: 18, color: AppLightModeColors.icons),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),

              // Re-inserting the Row of TextFields for 6 digits
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  // Use controller's codeControllers length, which will be 6
                  controller.codeControllers.length,
                      (index) => Container(
                    width: 55, // Adjusted width
                    height: 70, // Adjusted height
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
                          controller.onCodeChanged(value, index);
                          // Focus handling
                          if (value.isNotEmpty && index < controller.codeControllers.length - 1) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        style: const TextStyle(fontSize: 26.0),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Retained this SizedBox

              // Obx for the ElevatedButton (isLoading is observable)
              Obx(
                    () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.verifyCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    backgroundColor: AppLightModeColors.mainColor,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    'Verify',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: controller.resendCode,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16.0),
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
      ),
    );
  }
}