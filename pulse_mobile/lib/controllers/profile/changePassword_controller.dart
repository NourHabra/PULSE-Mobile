import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart';
import 'package:pulse_mobile/theme/app_light_mode_colors.dart'; // Import your color theme

class ChangePasswordController extends GetxController {
  // Get the ApiService instance
  final ApiService apiService = Get.find<ApiService>();

  // Form controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  // Rx variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  final RxBool showOldPassword = false.obs;
  final RxBool showNewPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;

  //  method to get the user's token.
  String? _getUserToken() {
    //  SharedPreferences,  Secure Storage, or from GetX.
    //  For example, if you stored it in GetX:
    // return Get.find<AuthController>().user.value?.authToken; // Adjust as needed.
    //  (You'd need an AuthController or similar)
    return "dummy_user_token"; //remove this
  }

  // Function to handle the password change
  Future<void> changePassword() async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    // Input validation
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields.';
      isLoading.value = false;
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage.value = 'New password and confirmation do not match.';
      isLoading.value = false;
      return;
    }

    //  Get the user's token.
    String? userToken = _getUserToken();
    if (userToken == null) {
      errorMessage.value = 'User token not found. Please log in again.';
      isLoading.value = false;
      return;
    }

    try {
      // Call the changePassword method from ApiService
      final response = await apiService.changePassword( // Make sure ApiService.changePassword has userToken
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        userToken: userToken, // Pass the userToken here
      );

      if (response['success'] == true) {
        successMessage.value = response['message'];
        // Clear the form fields on success
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        //  Consider navigating to a success screen or showing a dialog.
        // Get.to(()=> PasswordChangedSuccessfully());
      } else {
        errorMessage.value = response['message'] ??
            'Failed to change password. Please try again.';
      }
    } catch (error) {
      errorMessage.value = 'Error: ${error.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose of controllers
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

// ApiService (Assumed) -  Make sure this matches your actual ApiService class
class ApiService {
  // ... other methods

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String userToken, // Add userToken parameter here
  }) async {
    //  Implement your API call here.  This is just a placeholder.
    //  Include the userToken in your request headers or body.
    //  Example:
    // final response = await post(
    //   '/api/change-password',
    //   {
    //     'old_password': oldPassword,
    //     'new_password': newPassword,
    //   },
    //   headers: {'Authorization': 'Bearer $userToken'}, // Include token
    // );
    // if (response.statusCode == 200) {
    //   return jsonDecode(response.body);
    // } else {
    //   throw Exception('Failed to change password');
    // }
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    if (oldPassword == "test" && newPassword == "new") {
      return {'success': true, 'message': 'Password changed successfully!'};
    } else {
      return {'success': false, 'message': 'Invalid old password.'};
    }
  }
}
