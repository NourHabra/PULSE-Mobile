import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/signupModel.dart'; // Make sure this path is correct
import '../../services/connections.dart'; // Make sure this path is correct

class SignUpController extends GetxController {
  // --- Text Editing Controllers ---
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
  final fingerprintController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final pictureUrlController = TextEditingController();

  // --- Reactive Variables ---
  final isLoading = false.obs;
  final errorMessage = RxString('');
  final user = SignupUserModel(); // The model that holds all signup data
  final selectedDate = Rx<DateTime?>(null);

  // --- Navigation & UI State ---
  final currentPage = 1.obs; // Tracks the current page in a multi-step signup flow
  final isPasswordVisible = false.obs;
  final isTermsAgreed = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

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

    if (currentPage.value == 1) {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        errorMessage.value = 'Email, password, and confirm password are required.';
        print('Error (Page 1): ${errorMessage.value}');
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }
      if (!isValidEmail(emailController.text)) {
        errorMessage.value = 'Invalid email format.';
        print('Error (Page 1): ${errorMessage.value}');
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }
      if (passwordController.text.length < 8) {
        errorMessage.value = 'Password must be at least 8 characters.';
        print('Error (Page 1): ${errorMessage.value}');
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        errorMessage.value = 'Passwords do not match.';
        print('Error (Page 1): ${errorMessage.value}');
        Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
        return;
      }

      user.email = emailController.text.trim();
      user.password = passwordController.text.trim();
      errorMessage.value = ''; // Clear error message if validation passes
      currentPage.value = 2; // Increment page count for internal tracking
      print('Navigating to page 2 via Get.toNamed(/signup2)');
      Get.toNamed('/signup2'); // Navigate to the next page
    }
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      Get.back(); // Use Get.back() to pop the current page off the stack
    } else {
      Get.offAllNamed('/login'); // If on first page, go back to login screen
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
      initialDate: selectedDate.value ?? DateTime.now(), // Use selectedDate if already set
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // Cannot pick future dates
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      user.dateOfBirth = pickedDate.toIso8601String(); // Assign to model
      dateOfBirthController.text =
      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}"; // Update text field
    }
  }

  Future<void> completeSignup() async {
    isLoading.value = true;
    errorMessage.value = ''; // Clear previous errors

    // --- Assign all form field values to the user model ---
    user.firstName = firstNameController.text.trim();
    user.lastName = lastNameController.text.trim();
    user.mobileNumber = phoneNumberController.text.trim();
    user.dateOfBirth = selectedDate.value?.toIso8601String(); // Use the picked date
    user.placeOfBirth = placeOfBirthController.text.trim();
    user.height = double.tryParse(heightController.text.trim());
    user.weight = double.tryParse(weightController.text.trim());
    user.bloodType = bloodTypeController.text.trim();
    user.fingerprint = fingerprintController.text.trim();
    user.gender = genderController.text.trim();
    user.address = addressController.text.trim();
    user.pictureUrl = pictureUrlController.text.trim();





    // --- Client-side validation for Page 2 fields (and some cross-page checks) ---
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        selectedDate.value == null || // This ensures a date has been picked
        placeOfBirthController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty
    ) {
      errorMessage.value = 'All fields are required. Please fill in all details.';
      isLoading.value = false;
      print('Validation Error: ${errorMessage.value}');
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return; // Stop execution here if validation fails
    }

    if (user.height == null || user.height! <= 0) { // Check for valid positive number
      errorMessage.value = 'Invalid height format. Please use a positive number.';
      isLoading.value = false;
      print('Validation Error: ${errorMessage.value}');
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }
    if (user.weight == null || user.weight! <= 0) { // Check for valid positive number
      errorMessage.value = 'Invalid weight format. Please use a positive number.';
      isLoading.value = false;
      print('Validation Error: ${errorMessage.value}');
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }

    // Re-check password match for robustness, though ideally done on page 1
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match. Please go back and correct.';
      isLoading.value = false;
      print('Validation Error: ${errorMessage.value}');
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }

    if (!isTermsAgreed.value) {
      errorMessage.value = 'You must agree to the Terms of Service and Privacy Policy.';
      isLoading.value = false;
      print('Validation Error: ${errorMessage.value}');
      Get.snackbar('Validation Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange.shade400, colorText: Colors.white);
      return;
    }


    // --- API Call ---
    // Ensure that apiService.signUp method takes the `user` object and uses `user.toJson()`
    final response = await apiService.signUp(user);



    isLoading.value = false; // Turn off loading indicator regardless of success/failure
    FocusManager.instance.primaryFocus?.unfocus(); // Unfocus before navigation
    // --- Handle API Response ---
    if (response['success'] == true) {
      Get.snackbar('Success', response['message'] ?? 'Signup successful!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.shade400, colorText: Colors.white);
      Get.offAllNamed('/login'); // Navigate to login page
    } else {
      // This block executes if response['success'] is false or not present.
      errorMessage.value = response['message'] ?? 'An unknown signup error occurred.';
      print('DEBUG: Signup failed due to conditional check. Message: ${errorMessage.value}, API Error: ${response['error']}');
      Get.snackbar('Signup Failed', errorMessage.value, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade400, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    // Dispose the TextEditingControllers immediately and synchronously.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    placeOfBirthController.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodTypeController.dispose();
    fingerprintController.dispose();
    genderController.dispose();
    addressController.dispose();
    pictureUrlController.dispose();

    // Call super.onClose() last, after your disposals.
    super.onClose();

  }
}