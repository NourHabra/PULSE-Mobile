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
  final ThemeService _themeService = Get.put(ThemeService());

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
                Get.toNamed('/changepassword');
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
            Obx(() => SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color, // Adjust text color based on theme
                ),
              ),
              value: _themeService.isDarkMode.value,
              onChanged: (bool value) {
                _themeService.saveThemeToPrefs(value); // Save and update theme
              },
              activeColor: Theme.of(context).primaryColor, // Example: Use app's primary color
              inactiveThumbColor: AppLightModeColors.textFieldBorder, // Example: Lighter color for inactive thumb
              trackOutlineColor: MaterialStateProperty.all(AppLightModeColors.textFieldBorder), // Example: Outline color
              contentPadding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            )),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
