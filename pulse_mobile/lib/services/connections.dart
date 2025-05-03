import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Import for HttpClient
import 'package:http/io_client.dart'; // Import for IOClient
import 'package:image_picker/image_picker.dart';
import '../models/categoryModel.dart';
import '../models/medicationModel.dart';
import '../models/prescriptionListitemModel.dart';
import '../models/profile_model.dart';
import '../models/signupModel.dart';

class ApiService extends GetxService {
  final String baseUrl = 'https://192.168.18.222:8443';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _httpClient = _createHttpClient(); // Use custom client for HTTPS (dev only!)
  static const String _tokenKey = 'userToken';

  static http.Client _createHttpClient() {
    HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
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
  Future<Profile> getUserProfile() async {
    final String? token = await getToken();
    if (token == null) {
      return Profile(
        pictureUrl: 'https://via.placeholder.com/150',
        height: 175.0,
        weight: 70.0,
        bloodType: 'A+',
      );
    }
    final url = Uri.parse('$baseUrl/api/profile');
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Profile.fromJson(data);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return Profile(
        pictureUrl: 'https://via.placeholder.com/150',
        height: 175.0,
        weight: 70.0,
        bloodType: 'A+',
      );
    }
  }

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
  Future<Map<String, dynamic>> signUp(SignupUserModel user) async {
    if (user.bloodTestImage == null || user.idImage == null) {
      return {
        'success': false,
        'message': 'Please upload both blood test and ID images.',
      };
    }

    final url = Uri.parse('$baseUrl/api/auth/signup');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll(user.toJson());

    http.MultipartFile? bloodTestFile;
    http.MultipartFile? idFile;

    var bloodTestStream = http.ByteStream(user.bloodTestImage!.openRead());
    var bloodTestLength = await user.bloodTestImage!.length();
    bloodTestFile = http.MultipartFile(
      'bloodTestImage',
      bloodTestStream,
      bloodTestLength,
      filename: 'blood_test_image.jpg',
    );
    request.files.add(bloodTestFile);

    var idStream = http.ByteStream(user.idImage!.openRead());
    var idLength = await user.idImage!.length();
    idFile = http.MultipartFile(
      'idImage',
      idStream,
      idLength,
      filename: 'id_image.jpg',
    );
    request.files.add(idFile);

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Signup successful!',
        };
      } else {
        final responseData = json.decode(responseBody);
        return {
          'success': false,
          'message':
          responseData['message'] ?? 'Signup failed. Please try again.',
          'error': responseBody,
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

  // Data Fetching Services
  Future<List<Category>> getCategories() async {
    final String? token = await getToken();
    if (token == null) {
      return [
        Category(
            id: 1,
            title: 'Doctors',
            imageUrl:
            'https://via.placeholder.com/50/007BFF/FFFFFF?Text=Doctors'),
        Category(
            id: 2,
            title: 'Pharmacies',
            imageUrl:
            'https://via.placeholder.com/50/28A745/FFFFFF?Text=Pharmacies'),
        Category(
            id: 3,
            title: 'Laboratories',
            imageUrl:
            'https://via.placeholder.com/50/DC3545/FFFFFF?Text=Labs'),
      ];
    }
    final url = Uri.parse('$baseUrl/api/categories');
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => Category.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [
        Category(
            id: 1,
            title: 'Doctors',
            imageUrl:
            'https://via.placeholder.com/50/007BFF/FFFFFF?Text=Doctors'),
        Category(
            id: 2,
            title: 'Pharmacies',
            imageUrl:
            'https://via.placeholder.com/50/28A745/FFFFFF?Text=Pharmacies'),
        Category(
            id: 3,
            title: 'Laboratories',
            imageUrl:
            'https://via.placeholder.com/50/DC3545/FFFFFF?Text=Labs'),
      ];
    }
  }

  Future<List<Medication>> getCurrentMedications() async {
    final String? token = await getToken();
    if (token == null) {
      return _getFakeMedications(); // Return fake data if no token
    }
    final url = Uri.parse('$baseUrl/api/medications/current'); // Replace with your actual API endpoint
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Medication.fromJson(json as Map<String, dynamic>)).toList();
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

  Future<List<Prescription>> getPrescriptions() async {
    final String? token = await getToken();
    if (token == null) {
      return _getFakePrescriptions(); // Return fake data if no token
    }
    final url = Uri.parse('$baseUrl/api/prescriptions'); // Replace with your actual API endpoint
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Prescription.fromJson(json as Map<String, dynamic>)).toList();
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
      Prescription(id: 1, doctorName: 'Dr. Marcus Horizon', doctorSpeciality: 'Cardiologist', validUntil: '22/5/2025'),
      Prescription(id: 2, doctorName: 'Dr. Jane Smith', doctorSpeciality: 'Dermatologist', validUntil: '15/6/2025'),
      Prescription(id: 3, doctorName: 'Dr. Robert Jones', doctorSpeciality: 'Neurologist', validUntil: '01/6/2025'),
      Prescription(id: 4, doctorName: 'Dr. Emily White', doctorSpeciality: 'Pediatrician', validUntil: '10/5/2025'),
      Prescription(id: 5, doctorName: 'Dr. David Brown', doctorSpeciality: 'Orthopedist', validUntil: '28/5/2025'),
    ];
  }

  Future<List<dynamic>> fetchcategoryData(String endpoint) async {
    final String url = '$baseUrl/$endpoint';
    try {
      final response = await _httpClient.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch data from $endpoint: ${response.statusCode}, ${response.body}');
        // Return fake data on API error
        return _getFakeDoctorCategories();
      }
    } catch (e) {
      print('Error fetching data from $endpoint: $e');
      // Return fake data on exception
      return _getFakeDoctorCategories();
    }
  }

// Method to generate fake doctor category data
  List<dynamic> _getFakeDoctorCategories() {
    return [
      {
        'd_id': 101,
        'name': 'Cardiologists',
        'icon': 'heart',
      },
      {
        'd_id': 102,
        'name': 'Dermatologists',
        'icon': 'face',
      },
      {
        'd_id': 103,
        'name': 'Pediatricians',
        'icon': 'child',
      },
      {
        'd_id': 104,
        'name': 'Neurologists',
        'icon': 'brain',
      },
    ];
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}