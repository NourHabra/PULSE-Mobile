import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../theme/theme_service.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/med&presListItem.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Use GetX controller for theme state

  @override
  void initState() {
    super.initState();
    // No need to load here if ThemeService loads onInit.
    // The switch will observe the ThemeService's isDarkMode.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomListItem(
              title: 'Edit Profile',
              onTap: () {
                Get.toNamed('/editProfile');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: const Divider(
                color: AppLightModeColors.textFieldBorder,
                thickness: 1.0,
              ),
            ),
            CustomListItem(
              title: 'Reset Password',
              onTap: () {
                Get.toNamed('/login');
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: const Divider( // New Divider for dark mode switch
                color: AppLightModeColors.textFieldBorder,
                thickness: 1.0,
              ),
            ),
            // Dark Mode Switch

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
