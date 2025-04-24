import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'connections.dart';

class AuthService extends GetxService {
  final String baseUrl = 'http://10.0.2.2:8080';
  final ApiService _apiService = Get.find<ApiService>();
  final http.Client _httpClient = http.Client();

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/login/patient'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      print('HTTP Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final String? token = body['token'];
        if (token != null) {
          await _apiService.saveToken(token);
          return true;
        } else {
          print('Login successful, but no token found in response.');
          return false;
        }
      } else {
        print('Patient Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    } finally {}
  }

  Future<void> resetPasswordByEmail(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      body: {'email': email},
    );
    if (response.statusCode == 200) {
      Get.snackbar('Success', 'OTP sent to your email.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to send reset email. ${response.body}',
          snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to reset password (email)');
    }
  }

  Future<void> resetPasswordByPhone(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      body: {'phone': phoneNumber},
    );
    if (response.statusCode == 200) {
      Get.snackbar('Success', 'OTP sent to your phone number.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to send OTP to phone. ${response.body}',
          snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to send OTP (phone)');
    }
  }

  Future<void> verifyOTP(String identifier, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      body: {
        if (identifier.contains('@')) 'email': identifier,
        if (!identifier.contains('@')) 'phone': identifier,
        'otp': otp,
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar('Success', 'OTP verified successfully.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to verify OTP. ${response.body}',
          snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to verify OTP');
    }
  }

  Future<void> resetPassword(
      String identifier, String otp, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset'),
      body: {
        if (identifier.contains('@')) 'email': identifier,
        if (!identifier.contains('@')) 'phone': identifier,
        'otp': otp,
        'newPassword': newPassword,
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Password reset successfully.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to reset password. ${response.body}',
          snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to reset password');
    }
  }

  Future<bool> validateToken() async {
    final String? token = await _apiService.getToken();
    if (token == null) {
      return false;
    }
    final response = await http.get(
      Uri.parse('$baseUrl/api/validate-token'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}

