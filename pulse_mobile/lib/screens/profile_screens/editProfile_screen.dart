// screens/profile/editProfile_screen.dart
import 'dart:io'; // Required for FileImage
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/widgets/bottombar.dart';
import '../../controllers/profile/editProfile_controller.dart';
import '../../theme/app_light_mode_colors.dart';
import '../../widgets/appbar.dart';
import '../../widgets/editProfile_textfield.dart';

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
                    child: Obx(() {
                      // Display selected image or existing profile picture
                      ImageProvider imageProvider;
                      if (profileController.selectedImageFile != null) {
                        imageProvider = FileImage(File(profileController.selectedImageFile!.path));
                      } else if (profileController.profile.value?.pictureUrl != null &&
                          profileController.profile.value!.pictureUrl!.isNotEmpty) {
                        imageProvider = NetworkImage(profileController.profile.value!.pictureUrl!);
                      } else {
                        imageProvider = const AssetImage('assets/default_profile_image.png');
                      }
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: imageProvider,
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: profileController.pickImage,
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text('Change Picture', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppLightModeColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Adjusted spacing
                  Row(
                    children: [
                      const Text('Blood Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,color:AppLightModeColors.normalText)),
                      const SizedBox(width: 105),
                      Expanded(
                        child: EditTextField(
                          controller: profileController.bloodTypeController,
                          suffixText: '',
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
                              fontWeight: FontWeight.bold, fontSize: 20,color:AppLightModeColors.normalText)),
                      const SizedBox(width: 100),
                      Expanded(
                        child: EditTextField(
                          controller: profileController.weightController,
                          suffixText: 'kg',
                          onChanged: (value) {
                            profileController.weightController.text = value;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Height (cm)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20,color:AppLightModeColors.normalText)),
                      const SizedBox(width: 100),
                      Expanded(
                        child: EditTextField(
                          controller: profileController.heightController,
                          suffixText: 'cm',
                          onChanged: (value) {
                            profileController.heightController.text = value;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: profileController.saveUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppLightModeColors.mainColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 18.0),
                        child: Text(
                          'Save Profile',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
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
      bottomNavigationBar:  CustomBottomNavBar(),
    );
  }
}
