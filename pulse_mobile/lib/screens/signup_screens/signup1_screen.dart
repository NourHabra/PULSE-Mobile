import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/custom_textfield.dart';
import '../../controllers/signup/signup_controller.dart';

class SignUpPage1 extends GetView<SignUpController> {
  SignUpPage1({super.key});
  final currentPage = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Sign up'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.emailController,
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 10),
            Obx(() => CustomTextField(
              controller: controller.passwordController,
              hintText: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              obscureText: !controller.isPasswordVisible.value,
              suffixIcon: controller.isPasswordVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixIconTap: controller.togglePasswordVisibility,
            )),
            const SizedBox(height: 10),
            Obx(() => CustomTextField(
              controller: controller.confirmPasswordController,
              hintText: 'Confirm your password',
              prefixIcon: Icons.lock_outline,
              obscureText: !controller.isPasswordVisible.value,
              suffixIcon: controller.isPasswordVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onSuffixIconTap: controller.togglePasswordVisibility,
            )),
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
              controller.isLoading.value ? null : controller.goToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppLightModeColors.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?",
                    style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  child: const Text(
                    'Log in',
                    style: TextStyle(color: AppLightModeColors.mainColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}