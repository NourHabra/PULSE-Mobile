import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:pulse_mobile/theme/app_light_mode_colors.dart'; // Assuming you have your theme colors
import 'package:pulse_mobile/widgets/appbar.dart';

import '../../controllers/signup/signup_controller.dart';

class SignUpPage3 extends GetView<SignUpController> {
  const SignUpPage3({super.key});

  Future<void> _showImagePickerDialog(BuildContext context, bool isBloodTest) async {
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
                    controller.pickImage(ImageSource.gallery, isBloodTest);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  controller.pickImage(ImageSource.camera, isBloodTest);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder({required Rx<File?> imageFile, required bool isBloodTest}) {
    return SizedBox(
      width: 70, // Set the desired width here
      child: Obx(
            () => GestureDetector(
          onTap: () => _showImagePickerDialog(Get.context!, isBloodTest),
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

  // Widget _buildImageStatus({required Rx<File?> imageFile}) { // Comment out or delete this widget
  //   return Obx(
  //         () => imageFile.value != null
  //         ? Padding(
  //       padding: const EdgeInsets.only(top: 8.0),
  //       child: Text('Image Selected', style: TextStyle(color: AppLightModeColors.mainColor)),
  //     )
  //         : const SizedBox.shrink(),
  //   );
  // }

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
                _buildImagePlaceholder(imageFile: controller.idImage, isBloodTest: false),
                const SizedBox(width: 10), // Add some spacing after the placeholder
              ],
            ),
            // _buildImageStatus(imageFile: controller.idImage), // Comment out or delete this line
            const SizedBox(height: 40),
            Row(
              children: [
                const Expanded(
                  child: Text('General Blood Test', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                ),
                const SizedBox(width: 10),
                _buildImagePlaceholder(imageFile: controller.bloodTestImage, isBloodTest: true),
                const SizedBox(width: 10), // Add some spacing after the placeholder
              ],
            ),
            // _buildImageStatus(imageFile: controller.bloodTestImage), // Comment out or delete this line
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value || controller.idImage.value == null || controller.bloodTestImage.value == null
                    ? null
                    : controller.signUp,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}