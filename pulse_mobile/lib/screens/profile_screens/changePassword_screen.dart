import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import '../../controllers/profile/changePassword_controller.dart';
import '../../widgets/custom_textfield.dart';
import '../../theme/app_light_mode_colors.dart'; // Import your color theme

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller.
    final ChangePasswordController controller = Get.put(
        ChangePasswordController()); //moved to the build

    return Scaffold(
      appBar: CustomAppBar(titleText: 'Change Password'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
        child: Form(
          //  a GlobalKey if you need to validate the whole form at once.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              //  "Create a new password" Text
              const Text(
                "Create a new password",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppLightModeColors.normalText
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 30), // Add space between title and input
              // Old Password Input
              Obx(
                    () => CustomTextField(
                  controller: controller.oldPasswordController,
                  hintText: 'Old Password',
                  obscureText: controller.showOldPassword.value,
                  prefixIcon: FeatherIcons.lock,
                  suffixIcon: controller.showOldPassword.value
                      ? FeatherIcons.eye
                      : FeatherIcons.eyeOff,
                  onSuffixIconTap: () {
                    controller.showOldPassword.value =
                    !controller.showOldPassword.value;
                  },
                ),
              ),
              const SizedBox(height: 20),
              // New Password Input
              Obx(
                    () => CustomTextField(
                  controller: controller.newPasswordController,
                  hintText: 'New Password',
                  obscureText: controller.showNewPassword.value,
                  prefixIcon: FeatherIcons.lock,
                  suffixIcon: controller.showNewPassword.value
                      ? FeatherIcons.eye
                      : FeatherIcons.eyeOff,
                  onSuffixIconTap: () {
                    controller.showNewPassword.value =
                    !controller.showNewPassword.value;
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Confirm New Password Input
              Obx(
                    () => CustomTextField(
                  controller: controller.confirmPasswordController,
                  hintText: 'Confirm New Password',
                  obscureText: controller.showConfirmPassword.value,
                  prefixIcon: FeatherIcons.lock,
                  suffixIcon: controller.showConfirmPassword.value
                      ? FeatherIcons.eye
                      : FeatherIcons.eyeOff,
                  onSuffixIconTap: () {
                    controller.showConfirmPassword.value =
                    !controller.showConfirmPassword.value;
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Change Password Button
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    controller.changePassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightModeColors.mainColor,
                  ),
                  //  disable the button while loading
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 18.0),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
              // Error Message Display
              Obx(() {
                return Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                );
              }),
              // Success Message
              Obx(() {
                return Text(
                  controller.successMessage.value,
                  style: const TextStyle(color: Colors.green),
                );
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

