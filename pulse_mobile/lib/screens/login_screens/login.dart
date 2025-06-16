import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/controllers/login/login_controller.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import 'package:pulse_mobile/widgets/custom_textfield.dart';
import '../../widgets/appbar.dart';
import '../../widgets/socialSignin.dart';

// Change LoginPage from GetView to StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Declare TextEditingController instances here
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // 2. Get the LoginController instance for business logic
  // Make sure your LoginBinding is correctly set up in app_pages.dart
  final LoginController controller = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    print('LoginPageState initState called');
    // 3. Initialize TextEditingController instances
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // 4. If you had initial values in your LoginController for these fields,
    // you could set them here. But it's better to keep them local.
    // Example: _emailController.text = controller.someInitialEmailValue;

    // Optional: If you need to observe changes in the TextField directly in the controller,
    // you can add listeners here and update controller's Rx variables or internal state.
    // _emailController.addListener(() {
    //   // controller.updateEmailText(_emailController.text); // Example of updating controller
    // });
  }

  @override
  void dispose() {
    print('LoginPageState dispose called');
    // 5. Dispose the TextEditingController instances when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('LoginPageState build called');
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
                // 6. Assign the local controller here
                controller: _emailController,
                hintText: 'Enter your email',
                prefixIcon: FeatherIcons.mail,
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Obx(
                    () => CustomTextField(
                  // 7. Assign the local controller here
                  controller: _passwordController,
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
                        : () {
                      // 8. Pass the text values to the LoginController's login method
                      controller.loginWithCredentials(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
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
            
          ],
        ),
      ),
    );
  }
}