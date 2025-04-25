import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/signupModel.dart';
import '../../services/connections.dart';

class SignUpController extends GetxController {
  // --- Text Editing Controllers ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // Add confirm password controller
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // --- Reactive Variables ---
  final isLoading = false.obs;
  final errorMessage = RxString('');
  final user = SignupUserModel();
  final selectedDate = Rx<DateTime?>(null);
  final bloodTestImage = Rx<File?>(null);
  final idImage = Rx<File?>(null);

  // --- Navigation ---
  final currentPage = 1.obs;
  final isPasswordVisible = false.obs; // Add this
  final isTermsAgreed = false.obs; // ADD THIS LINE

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ADD THIS METHOD
  void setTermsAgreed(bool? value) {
    isTermsAgreed.value = value ?? false;
  }

  // --- ApiService Instance ---
  final ApiService apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
  }

  void goToNextPage() {
    print('Current Page: ${currentPage.value}');
    print('Email: ${emailController.text}');
    print('Password: ${passwordController.text}');
    print('Confirm Password: ${confirmPasswordController.text}');

    if (currentPage.value == 1) {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        errorMessage.value = 'Email, password, and confirm password are required.';
        print('Error: ${errorMessage.value}');
        return;
      }
      if (!isValidEmail(emailController.text)) {
        errorMessage.value = 'Invalid email format.';
        print('Error: ${errorMessage.value}');
        return;
      }
      if (passwordController.text.length < 8) {
        errorMessage.value = 'Password must be at least 8 characters.';
        print('Error: ${errorMessage.value}');
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        errorMessage.value = 'Passwords do not match.';
        print('Error: ${errorMessage.value}');
        return;
      }

      user.email = emailController.text.trim();
      user.password = passwordController.text.trim(); // Only set password if it matches
      errorMessage.value = '';
      currentPage.value = 2;
      print('Navigating to page 2');
      Get.toNamed('/signup2');
    } else if (currentPage.value == 2) {
      user.firstName = firstNameController.text.trim();
      user.lastName = lastNameController.text.trim();
      user.phoneNumber = phoneNumberController.text.trim();
      user.dateOfBirth = selectedDate.value?.toIso8601String();
      user.placeOfBirth = placeOfBirthController.text.trim();

      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          selectedDate.value == null ||
          placeOfBirthController.text.isEmpty ||
          heightController.text.isEmpty || // Check if the field is empty before parsing
          weightController.text.isEmpty) { // Check if the field is empty before parsing
        errorMessage.value = 'All fields are required.';
        return;
      }

      try {
        user.height = double.parse(heightController.text.trim());
      } catch (e) {
        errorMessage.value = 'Invalid height format. Please use a number.';
        return;
      }
      try {
        user.weight = double.parse(weightController.text.trim());
      } catch (e) {
        errorMessage.value = 'Invalid weight format. Please use a number.';
        return;
      }

      errorMessage.value = '';
      currentPage.value = 3;
      Get.toNamed('/signup3');
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      user.dateOfBirth = pickedDate.toIso8601String();
      dateOfBirthController.text =
      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  Future<void> pickImage(ImageSource source, bool isBloodTest) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        if (isBloodTest) {
          bloodTestImage.value = imageFile;
          user.bloodTestImage = imageFile;
        } else {
          idImage.value = imageFile;
          user.idImage = imageFile;
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      errorMessage.value = 'Error picking image: $e';
      print('Error picking image: $e');
    }
  }

  Future<void> signUp() async {
    isLoading.value = true;
    errorMessage.value = '';

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match.';
      isLoading.value = false;
      return;
    }

    if (user.bloodTestImage == null || user.idImage == null) {
      errorMessage.value = 'Please upload both images.';
      isLoading.value = false;
      return;
    }

    final response = await apiService.signUp(user); // Call the signUp method

    isLoading.value = false; //  Set this *inside* the finally block
    if (response['success']) {
      Get.snackbar('Success', response['message'],
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/login');
    } else {
      errorMessage.value = response['message'];
      print('Signup failed: ${response['error']}'); // Log the error
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); // Dispose the confirm password controller
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    placeOfBirthController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}