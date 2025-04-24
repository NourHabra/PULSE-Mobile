import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/categoryModel.dart';
import '../models/profile_model.dart';

class ApiService extends GetxService {
  final String baseUrl = 'http://10.0.2.2:8080';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _httpClient = http.Client();
  static const String _tokenKey = 'userToken';

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
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

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
