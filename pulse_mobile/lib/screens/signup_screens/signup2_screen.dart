import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart';
import 'package:pulse_mobile/widgets/custom_textfield.dart';

import '../../controllers/signup/signup_controller.dart';

class SignUpPage2 extends GetView<SignUpController> {
  const SignUpPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Sign Up', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.firstNameController,
                hintText: 'First Name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: controller.lastNameController,
                hintText: 'Last Name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: controller.phoneNumberController,
                hintText: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.heightController,
                      hintText: 'Height',
                      prefixIcon: Icons.straighten_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('cm', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomTextField(
                      controller: controller.weightController,
                      hintText: 'Weight',
                      prefixIcon: Icons.fitness_center_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('kg', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => controller.selectDate(context),
                child: CustomTextField(
                  controller: controller.dateOfBirthController,
                  hintText: 'dd/mm/yyyy',
                  prefixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: controller.placeOfBirthController,
                hintText: 'Place of Birth',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 20),
              Obx(() => Row(
                children: [
                  Checkbox(
                    value: controller.isTermsAgreed.value,
                    onChanged: controller.setTermsAgreed,
                    activeColor: AppLightModeColors.mainColor,
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to the PULSE Terms of Service and Privacy Policy',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 20),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value || !controller.isTermsAgreed.value
                      ? null
                      : controller.navigateToSignUpPage3, // Changed to navigateToSignUpPage3
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppLightModeColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Next', // Changed button text to 'Next'
                    style:
                    TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/login'); // Assuming you have a /login route
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: AppLightModeColors.mainColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}