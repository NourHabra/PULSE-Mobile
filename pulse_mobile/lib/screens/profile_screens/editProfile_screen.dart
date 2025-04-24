import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import '../../controllers/profile/editProfile_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/editProfile_textfield.dart'; // Ensure this uses suffixText

class EditProfileScreen extends StatelessWidget {
  final EditProfileController profileController = Get.put(EditProfileController());

  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Edit Profile',
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (profileController.errorMessage.isNotEmpty) {
          return Center(child: Text(profileController.errorMessage.value));
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                      profileController.profile.value?.pictureUrl != null
                          ? NetworkImage(
                          profileController.profile.value!.pictureUrl!)
                          : const AssetImage(
                          'assets/default_profile_image.png')
                      as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const Text('Blood Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(width: 105),
                      Expanded(
                        child: EditTextField(
                          controller: profileController.bloodTypeController,
                          suffixText: '', // Changed to suffixText
                          onChanged: (value) {
                            profileController.bloodTypeController.text = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Weight (kg)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(width: 100),
                      Expanded(
                        child: EditTextField(
                          controller: profileController.weightController,
                          suffixText: 'kg', // Changed to suffixText
                          onChanged: (value) {
                            profileController.weightController.text = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Height (cm)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(width: 100),
                      Expanded(
                        child: EditTextField(
                          controller: profileController.heightController,
                          suffixText: 'cm', // Changed to suffixText
                          onChanged: (value) {
                            profileController.heightController.text = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center( // Wrap the button with a Center widget
                    child: ElevatedButton(
                      onPressed: profileController.saveUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppLightModeColors
                            .mainColor, // Use the same background color
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            100.0, // Use the specified horizontal padding
                            vertical: 18.0), // Keep the vertical padding
                        child: Text(
                          'Save Profile', // Keep the original text
                          style: TextStyle(
                            fontSize: 18.0, // Use the same font size
                            color: Colors.white, // Use the same text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

