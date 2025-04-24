import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/appbar.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/bottombar.dart';
import '../../widgets/med&presListItem.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Settings'),
      body: SingleChildScrollView( // Changed to SingleChildScrollView
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
              child: const Divider( // Moved Divider here
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
