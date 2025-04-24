import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import '../../controllers/login/forgotPassword_controller.dart';
import '../../widgets/appbar.dart';
import '../../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

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
              'Forgot Your Password?',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter your email or phone number, and we will send you a reset link.',
              style: TextStyle(fontSize: 18, color: AppLightModeColors.icons),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            // Segmented Control (Slider)
            Container( // Added a Container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24), // Rounded corners for the whole slider
                color: AppLightModeColors.textFieldBackground, // Blue background
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.isEmail.value = true;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: controller.isEmail.value
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: controller.isEmail.value
                                  ? AppLightModeColors.mainColor
                                  : AppLightModeColors.icons,

                              fontSize: controller.isEmail.value
                                  ? 16
                                  : 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.isEmail.value = false;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !controller.isEmail.value
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            'Phone',
                            style: TextStyle(
                              color: !controller.isEmail.value
                                  ? AppLightModeColors.mainColor
                                  : AppLightModeColors.icons,

                              fontSize: controller.isEmail.value
                                  ? 16
                                  : 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ), // Added the closing ),
            const SizedBox(height: 30),
            // Input Field
            Obx(() => CustomTextField(
              controller: controller.emailController, //  controller
              hintText: controller.isEmail.value ? 'Email' : 'Phone Number',
              prefixIcon:
              controller.isEmail.value ? FeatherIcons.mail : FeatherIcons.phone,
            )),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.resetPassword,
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
                'Reset Password',
                style:
                TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            )),

          ],
        ),

      ),
    );
  }
}