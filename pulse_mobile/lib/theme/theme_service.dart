import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/med&presListItem.dart';

// You might need a way to actually switch the theme globally.
// A simple GetX service or ThemeController could be used.
class ThemeService extends GetxService {
  RxBool isDarkMode = false.obs;
  static const String _keyDarkMode = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  // Load the theme preference from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_keyDarkMode) ?? false;
    // You would then apply this theme to your app here, e.g., using Get.changeTheme()
    // For demonstration, we'll just update the switch state.
  }

  // Save the theme preference to SharedPreferences
  Future<void> saveThemeToPrefs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
    isDarkMode.value = value;
    // Apply the new theme globally
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
