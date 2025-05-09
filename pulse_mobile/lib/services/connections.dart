import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import '../models/categoryModel.dart';
import '../models/doctor_model_featured_homepage.dart';
import '../models/medicationModel.dart';
import '../models/prescriptionListitemModel.dart';
import '../models/profile_model.dart';
import '../models/signupModel.dart';
import '../models/vitals_model.dart';

class ApiService extends GetxService {
  final String baseUrl = 'https://192.168.181.222:8443';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _httpClient =
  _createHttpClient(); // Use custom client for HTTPS
  static const String _tokenKey = 'userToken';



  static http.Client _createHttpClient() {
    HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return IOClient(client);
  }

  @override
  void onInit() {
    super.onInit();
  }

  // Token Management
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Authentication Services
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
      print('HTTP Status Code (Login): ${response.statusCode}');
      print('Response Body (Login): ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final String? token = body['token'];
        print('///////////');
        print(token);
        print('////////');
        if (token != null) {
          await saveToken(token);
          print('yes token');
          return true;
        } else {
          print('Login successful, but no token found in response.');
          return false;
        }
      } else {
        print('Patient Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } on SocketException catch (e) {
      print('Network error during login: $e');
      return false;
    } on FormatException catch (e) {
      print('JSON decoding error during login: $e');
      return false;
    } catch (e) {
      print('An unexpected error occurred during login: $e');
      return false;
    }
  }

  Future<void> resetPasswordByEmail(String email) async {
    final response = await _httpClient.post( // Use _httpClient
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
    final response = await _httpClient.post( // Use _httpClient
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

  Future<Map<String, dynamic>> verifyCode({
    required bool isEmail,
    required String contact,
    required String code,
  }) async {
    final url = Uri.parse('$baseUrl/verify-code');
    final response = await _httpClient.post(
      url,
      body: {
        if (isEmail) 'email': contact else 'phone': contact,
        'code': code,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data['token'];
      await saveToken(token);
      return {
        'success': true,
        'message': 'Code verified successfully',
        'token': token,
      };
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(
          'Failed to verify code: ${response.statusCode}, ${errorData['message']}');
    }
  }

  Future<Map<String, dynamic>> resendCode({
    required bool isEmail,
    required String contact,
  }) async {
    final url = Uri.parse('$baseUrl/resend-code');
    final response = await _httpClient.post(
      url,
      body: {if (isEmail) 'email': contact else 'phone': contact},
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Code resent successfully',
      };
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(
          'Failed to resend code: ${response.statusCode}, ${errorData['message']}');
    }
  }

  Future<void> verifyOTP(String identifier, String otp) async {
    final response = await _httpClient.post( // Use _httpClient
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
    final response = await _httpClient.post( // Use _httpClient
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
    final String? token = await getToken();
    if (token == null) {
      return false;
    }
    final response = await _httpClient.get( // Use _httpClient
      Uri.parse('$baseUrl/api/validate-token'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  // User Profile Services
  ////get profile
  Future<Profile> getUserProfile() async {
    final String? token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated'); //  Important: Throw an exception
    }
    final url = Uri.parse('$baseUrl/auth/profile/patient'); // Corrected URL
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        return Profile.fromJson(data);
      } else {
        // Handle different error codes more specifically (optional)
        if (response.statusCode == 404) {
          throw Exception('Profile not found');
        } else {
          throw Exception(
              'Failed to fetch profile: ${response.statusCode}, ${response.body}'); // Include body
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }
/////edit profile
  Future<Profile> getUserProfileEdit(String token) async {
    try {
      final url = Uri.parse('$baseUrl/user/profile');
      if (token == null) {
        return Profile(
          pictureUrl: 'https://via.placeholder.com/150',
          height: 170.0,
          weight: 65.0,
          bloodType: 'O-',
        );
      }

      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Profile.fromJson(data);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return Profile(
        pictureUrl: 'https://via.placeholder.com/150',
        height: 170.0,
        weight: 65.0,
        bloodType: 'O-',
      );
    }
  }
////change password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final String? token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    final url = Uri.parse('$baseUrl/change-password');
    final response = await _httpClient.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return {
        'success': true,
        'message': data['message'] ?? 'Password changed successfully',
      };
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(
          'Failed to change password: ${response.statusCode}, ${errorData['message']}');
    }
  }

  Future<void> updateUserProfile(String token, Profile profile) async {
    if (token == null) {
      throw Exception('User not authenticated');
    }
    final url = Uri.parse('$baseUrl/user/profile');
    final response = await _httpClient.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update profile: ${response.statusCode}, ${response.body}');
    }
  }

  // Signup Service
  // Signup Service
  Future<Map<String, dynamic>> signUp(SignupUserModel user) async {
    final url = Uri.parse('$baseUrl/auth/register/patient');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      final response = await _httpClient.post(
        url,
        headers: headers,
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Signup successful!',
        };
      } else {
        final responseData = json.decode(response.body);
        return {
          'success': false,
          'message':
          responseData['message'] ?? 'Signup failed. Please try again.',
          'error': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'error': e.toString(),
      };
    }
  }


//// get current medications
  Future<List<Medication>> getCurrentMedications() async {
    final String? token = await getToken();
    if (token == null) {
      return _getFakeMedications(); // Return fake data if no token
    }
    final url =
    Uri.parse('$baseUrl/api/medications/current'); // Replace with your actual API endpoint
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => Medication.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('API Error (Current Medications): ${response.statusCode}');
        return _getFakeMedications(); // Return fake data on API error
      }
    } catch (e) {
      print('Error fetching current medications: $e');
      return _getFakeMedications(); // Return fake data on exception
    }
  }

  // Method to generate fake medication data
  List<Medication> _getFakeMedications() {
    return [
      Medication(
        tradeName: 'Fake Panadol',
        pharmaComposition: 'Fake Acetaminophen',
        numOfTimes: 'Once a day',
        untilDate: '30/5/2025',
      ),
      Medication(
        tradeName: 'Fake Advil',
        pharmaComposition: 'Fake Ibuprofen',
        numOfTimes: 'Twice a day',
        untilDate: '05/6/2025',
      ),
      Medication(
        tradeName: 'Fake Claritin',
        pharmaComposition: 'Fake Loratadine',
        numOfTimes: 'Once a day',
        untilDate: '15/6/2025',
      ),
    ];
  }
////get all prescriptions
  Future<List<Prescription>> getPrescriptions() async {
    final String? token = await getToken();
    if (token == null) {
      return _getFakePrescriptions(); // Return fake data if no token
    }
    final url =
    Uri.parse('$baseUrl/api/prescriptions'); // Replace with your actual API endpoint
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => Prescription.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('API Error (Get Prescriptions): ${response.statusCode}');
        return _getFakePrescriptions(); // Return fake data on API error
      }
    } catch (e) {
      print('Error fetching prescriptions: $e');
      return _getFakePrescriptions(); // Return fake data on exception
    }
  }

  // Method to generate fake prescription data
  List<Prescription> _getFakePrescriptions() {
    return [
      Prescription(
          id: 1,
          doctorName: 'Dr. Marcus Horizon',
          doctorSpeciality: 'Cardiologist',
          validUntil: '22/5/2025'),
      Prescription(
          id: 2,
          doctorName: 'Dr. Jane Smith',
          doctorSpeciality: 'Dermatologist',
          validUntil: '15/6/2025'),
      Prescription(
          id: 3,
          doctorName: 'Dr. Robert Jones',
          doctorSpeciality: 'Neurologist',
          validUntil: '01/6/2025'),
      Prescription(
          id: 4,
          doctorName: 'Dr. Emily White',
          doctorSpeciality: 'Pediatrician',
          validUntil: '10/5/2025'),
      Prescription(
          id: 5,
          doctorName: 'Dr. David Brown',
          doctorSpeciality: 'Orthopedist',
          validUntil: '28/5/2025'),
    ];
  }
////fetch doctors of each category
  /*Future<List<dynamic>> fetchcategoryData(String endpoint) async {
    List<dynamic> _getCategoryDataWithAssets() {
      return [
        {
          'd_id': 101,
          'name': 'Cardiologists',
          'icon': 'assets/cardiology_600dp.png', //  asset path
        },
        {
          'd_id': 102,
          'name': 'Dermatologists',
          'icon': 'assets/accessibility_600dp.png', // asset path
        },
        {
          'd_id': 103,
          'name': 'Pediatricians',
          'icon': 'assets/child_friendly_600dp.png', // asset path
        },
        {
          'd_id': 104,
          'name': 'Neurologists',
          'icon': 'assets/neurology_600dp_.png', // asset path
        },
        {
          'd_id': 105,
          'name': 'Internal Medicine',
          'icon': 'assets/gastroenterology_600dp.png', // asset path
        },
      ];
    }

    return _getCategoryDataWithAssets();
  }*/


///////////get vitals of patient in home page
  Future<List<Vital>?> getPatientVitals() async {
    final url = Uri.parse('$baseUrl/testing/patient-vitals/me');
    final token = await _storage.read(key: _tokenKey);
    if (token == null) {
      return null; // Or handle no token as needed
    }

    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Map each item in the list to a Vital object
        return data.map((item) => Vital.fromJson(item as Map<String, dynamic>)).toList();
      } else if (response.statusCode == 404) {
        return null;
      } else {
        print(
            'Failed to load patient vitals: ${response.statusCode}, body: ${response.body}');
        return null; // Or throw an error as needed
      }
    } catch (e) {
      print('Error fetching vitals: $e');
      return null; // Or throw an error as needed
    }
    // finally { // REMOVE THIS BLOCK
    //   _httpClient.close();
    // }
  }



////fetch categories of the home page and saved page
  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/static/categories');

    try {
      final response = await _httpClient.get(url); // Use your custom client here

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        return data
            .map((json) => Category.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print(
            'Failed to fetch categories from network: ${response.statusCode}, body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching categories from network: $e');
      return [];
    }
  }
///////////// Fetch Featured Doctors (as a Future<List<FeaturedDoctor>>)
  Future<List<FeaturedDoctor>> fetchFeaturedDoctorsFromApi() async {
    final url = Uri.parse('$baseUrl/auth/featured-doctors');
    final token = await getToken();

    try {
      final response = await _httpClient.get(
        url,
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      print('HTTP Status Code (Featured Doctors): ${response.statusCode}');
      print('Response Body (Featured Doctors): ${response.body}');

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => FeaturedDoctor.fromJson(json)).toList();
      } else {
        print(
            'Failed to fetch featured doctors: ${response.statusCode}, ${response.body}');
        return []; // Return an empty list on failure
      }
    } catch (e) {
      print('Error fetching featured doctors: $e');
      return []; // Return an empty list on error
    }
  }

/////////////get all doctors for search
  Future<List<dynamic>> getAllDoctors() async {
    final String? token = await getToken();
    if (token == null) {
      throw Exception('No token available');
    }
    final url = Uri.parse('$baseUrl/auth/doctors');
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API Error (Get All Doctors): ${response.statusCode}');
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      print('Error fetching all doctors: $e');
      throw Exception('Failed to connect to the server');
    }
  }


  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
