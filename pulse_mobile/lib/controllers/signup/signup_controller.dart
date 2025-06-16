// signup_controller.dart
import 'dart:io';
import 'dart:convert'; // Added for jsonEncode
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // Added for http.MultipartFile and http.Response
import 'package:http_parser/http_parser.dart'; // Added for MediaType

import '../../models/signupModel.dart';
import '../../services/connections.dart'; // Ensure this points to your ApiService

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final bloodTypeController = TextEditingController();

  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final pictureUrlController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxString('');
  final user = SignupUserModel();
  final selectedDate = Rx<DateTime?>(null);

  final idImage = Rx<File?>(null);
  final profileImage = Rx<File?>(null);

  final currentPage = 1.obs;
  final isPasswordVisible = false.obs;
  final isTermsAgreed = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setTermsAgreed(bool? value) {
    isTermsAgreed.value = value ?? false;
  }

  final ApiService apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickImage(ImageSource source, bool isProfileImage) async {
    print('Attempting to pick image from source: $source, isProfileImage: $isProfileImage');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (isProfileImage) {
        profileImage.value = File(pickedFile.path);
        print('Profile image successfully picked and assigned: ${profileImage.value?.path}');
      } else {
        idImage.value = File(pickedFile.path);
        print('ID Image successfully picked and assigned: ${idImage.value?.path}');
      }
      errorMessage.value = '';
    } else {
      errorMessage.value = 'No image selected.';
      print('Image picking cancelled or failed. Error: ${errorMessage.value}');
    }
    print('Current idImage.value after pickImage: ${idImage.value}');
    print('Current profileImage.value after pickImage: ${profileImage.value}');
  }

  void goToNextPage() {
    if (currentPage.value == 1) {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        errorMessage.value = 'Email, password, and confirm password are required.';
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }
      if (!isValidEmail(emailController.text)) {
        errorMessage.value = 'Invalid email format.';
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }
      if (passwordController.text.length < 8) {
        errorMessage.value = 'Password must be at least 8 characters.';
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        errorMessage.value = 'Passwords do not match.';
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }

      user.email = emailController.text.trim();
      user.password = passwordController.text.trim();
      errorMessage.value = '';
      currentPage.value = 2;
      Get.toNamed('/signup2');
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      Get.back();
    } else {
      Get.offAllNamed('/login');
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
      initialDate: selectedDate.value ?? DateTime.now(),
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

  void navigateToSignUpPage3() {
    isLoading.value = true;
    errorMessage.value = '';

    user.firstName = firstNameController.text.trim();
    user.lastName = lastNameController.text.trim();
    user.mobileNumber = phoneNumberController.text.trim();
    user.dateOfBirth = selectedDate.value?.toIso8601String();
    user.placeOfBirth = placeOfBirthController.text.trim();
    user.height = double.tryParse(heightController.text.trim());
    user.weight = double.tryParse(weightController.text.trim());
    user.bloodType = bloodTypeController.text.trim();

    user.gender = genderController.text.trim();
    user.address = addressController.text.trim();
    user.pictureUrl = pictureUrlController.text.trim();

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        selectedDate.value == null ||
        placeOfBirthController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty
    ) {
      errorMessage.value = 'All fields are required. Please fill in all details.';
      isLoading.value = false;
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }

    if (user.height == null || user.height! <= 0) {
      errorMessage.value = 'Invalid height format. Please use a positive number.';
      isLoading.value = false;
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }
    if (user.weight == null || user.weight! <= 0) {
      errorMessage.value = 'Invalid weight format. Please use a positive number.';
      isLoading.value = false;
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match. Please go back and correct.';
      isLoading.value = false;
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }

    if (!isTermsAgreed.value) {
      errorMessage.value = 'You must agree to the Terms of Service and Privacy Policy.';
      isLoading.value = false;
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }

    isLoading.value = false;
    currentPage.value = 3;
    print('Navigating to SignUpPage3. isLoading set to false.');
    Get.toNamed('/signup3');
  }

  Future<void> signUp() async {
    isLoading.value = true;
    errorMessage.value = '';
    print('Attempting final signup. isLoading: ${isLoading.value}');

    // Assign the picked files to the SignupUserModel.
    // If idImage.value or profileImage.value are null, they will be assigned as null,
    // and the ApiService will handle sending them conditionally.
    user.idImageFile = idImage.value;
    user.pictureFile = profileImage.value;

    final response = await apiService.signUp(user);

    isLoading.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
    print('Signup API call completed. isLoading: ${isLoading.value}');

    if (response['success'] == true) {
      Get.snackbar('Success', response['message'] ?? 'Signup successful!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.shade400, colorText: Colors.white);

      print('[SignUpController] Calling Get.offAllNamed(/login_redirect)');
      Get.offAllNamed('/login_redirect');
    } else {
      errorMessage.value = response['message'] ?? 'An unknown signup error occurred.';
      Get.snackbar('Signup Failed', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade400, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    placeOfBirthController.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodTypeController.dispose();

    genderController.dispose();
    addressController.dispose();
    pictureUrlController.dispose();

    idImage.close();
    profileImage.close();
    super.onClose();
  }
}