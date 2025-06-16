// signup_page_3.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import 'package:pulse_mobile/widgets/appbar.dart';

import '../../controllers/signup/signup_controller.dart';

class SignUpPage3 extends GetView<SignUpController> {
  const SignUpPage3({super.key});

  Future<void> _showImagePickerDialog(BuildContext context, bool isProfileImage) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Device'),
                  onTap: () {
                    controller.pickImage(ImageSource.gallery, isProfileImage);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  controller.pickImage(ImageSource.camera, isProfileImage);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder({required Rx<File?> imageFile, required bool isProfileImage}) {
    return SizedBox(
      width: 70,
      child: Obx(
            () => GestureDetector(
          onTap: () => _showImagePickerDialog(Get.context!, isProfileImage),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppLightModeColors.textFieldBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppLightModeColors.textFieldBorder, width: 1),
            ),
            child: imageFile.value != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile.value!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : const Center(
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Sign up'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload The Following Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                const Expanded(
                  child: Text('ID Image', style: TextStyle( fontWeight: FontWeight.bold,fontSize: 17)),
                ),
                const SizedBox(width: 10),
                _buildImagePlaceholder(imageFile: controller.idImage, isProfileImage: false), // isProfileImage: false for ID
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 40), // Spacing for new row
            Row( // NEW: Row for Profile Image
              children: [
                const Expanded(
                  child: Text('Profile Picture', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)), // Changed text
                ),
                const SizedBox(width: 10),
                _buildImagePlaceholder(imageFile: controller.profileImage, isProfileImage: true), // isProfileImage: true for profile
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            )),
            const Spacer(),
            Obx(
                  () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // The button is now enabled as long as not loading
                  onPressed: controller.isLoading.value ? null : controller.signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightModeColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}