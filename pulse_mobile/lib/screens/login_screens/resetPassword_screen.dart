// Your existing ResetNewPasswordScreen code remains the same.
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import '../../controllers/login/reset_newPassword_controller.dart';
import '../../widgets/appbar.dart';
import '../../widgets/custom_textfield.dart';

class ResetNewPasswordScreen extends GetView<ResetNewPasswordController> {
  const ResetNewPasswordScreen({super.key});

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
              'Reset Password',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            const Text(
              'Set your new password below.',
              style: TextStyle(fontSize: 18, color: AppLightModeColors.icons),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            // New Password Input
            Obx(() => CustomTextField(
              controller: controller.newPasswordController,
              hintText: 'New Password',
              prefixIcon: FeatherIcons.lock,
              obscureText: controller.obscureNewPassword.value,
              suffixIcon: controller.obscureNewPassword.value
                  ? FeatherIcons.eyeOff
                  : FeatherIcons.eye,
              onSuffixIconTap: controller.toggleNewPasswordVisibility,
            )),
            const SizedBox(height: 20),
            // Confirm New Password Input
            Obx(() => CustomTextField(
              controller: controller.confirmPasswordController,
              hintText: 'Confirm New Password',
              prefixIcon: FeatherIcons.lock,
              obscureText: controller.obscureConfirmPassword.value,
              suffixIcon: controller.obscureConfirmPassword.value
                  ? FeatherIcons.eyeOff
                  : FeatherIcons.eye,
              onSuffixIconTap: controller.toggleConfirmPasswordVisibility,
            )),
            const SizedBox(height: 30),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.performPasswordReset,
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