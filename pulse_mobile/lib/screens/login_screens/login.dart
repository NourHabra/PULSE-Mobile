import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/login/login_controller.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import 'package:pulse_mobile/widgets/custom_textfield.dart';
import '../../widgets/appbar.dart';
import '../../widgets/socialSignin.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Login',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: CustomTextField(
                controller: controller.emailController,
                hintText: 'Enter your email',
                prefixIcon: FeatherIcons.mail,
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Obx(
                    () => CustomTextField(
                  controller: controller.passwordController,
                  hintText: 'Enter your password',
                  prefixIcon: FeatherIcons.lock,
                  suffixIcon: controller.isPasswordVisible.value
                      ? FeatherIcons.eye
                      : FeatherIcons.eyeOff,
                  obscureText: !controller.isPasswordVisible.value,
                  onSuffixIconTap: controller.togglePasswordVisibility,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.forgotPassword,
                  style: TextButton.styleFrom(
                    foregroundColor: AppLightModeColors.mainColor,
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                    () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.login, // Call the login method from the controller
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      backgroundColor: AppLightModeColors.mainColor,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text(
                      'Login',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 17,
                    color: AppLightModeColors.icons,
                  ),
                ),
                TextButton(
                  onPressed: controller.goToSignUp,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 17,
                      color: AppLightModeColors.mainColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Row(
              children: <Widget>[
                Expanded(
                    child: Divider(
                      color: AppLightModeColors.textFieldBorder,
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 17,
                      color: AppLightModeColors.icons,
                    ),
                  ),
                ),
                Expanded(
                    child: Divider(
                      color: AppLightModeColors.textFieldBorder,
                    )),
              ],
            ),
            const SizedBox(height: 25.0),
            SocialSignInButton(
              onPressed: controller.signInWithGoogle,
              icon: Image.asset(
                'assets/Google_Icon.webp',
                height: 32.0,
              ),
              label: 'Sign in with Google',
              iconPadding: const EdgeInsets.only(left: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            SocialSignInButton(
              onPressed: controller.signInWithApple,
              icon: Image.asset(
                'assets/Apple-Logo.png',
                height: 24.0,
              ),
              label: 'Sign in with Apple',
              iconPadding: const EdgeInsets.only(left: 20),
            ),
          ],
        ),
      ),
    );
  }
}