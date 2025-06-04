import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:pulse_mobile/models/mySavedDoctor_model.dart';
import '../models/LabModel.dart';
import '../models/categoryModel.dart';
import '../models/doctor_model_featured_homepage.dart';
import '../models/emergencyEvent.dart';
import '../models/generalDoctorModel.dart';
import '../models/labTestModel.dart';
import '../models/medical_record_details_model.dart';
import '../models/medicalrecordlistitemsModel.dart';
import '../models/medicationModel.dart';
import '../models/mySavedLab_model.dart';
import '../models/mySavedPharmacy_model.dart';
import '../models/prescriptionListitemModel.dart';
import '../models/profile_model.dart';
import '../models/signupModel.dart';
import '../models/vitals_model.dart';

class ApiService extends GetxService {
  final String baseUrl = 'https://192.168.190.222:8443';
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

  // sign up
  // In ApiService
  Future<Map<String, dynamic>> signUp(SignupUserModel user) async {
    final url = Uri.parse('$baseUrl/auth/register/patient');

    try {
      final httpResponse = await _httpClient.post( // Renamed to httpResponse to avoid confusion
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      print('HTTP Status Code (Signup): ${httpResponse.statusCode}');
      print('Response Body (Signup): ${httpResponse.body}');

      // Parse the response body first, as it contains the actual message
      final responseData = json.decode(httpResponse.body);
      final String serverMessage = responseData['message'] ?? 'No message from server.';

      // Check for success based on the status code AND potentially the message
      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
        // It's a success!
        return {
          'success': true,
          'message': serverMessage, // Use the message from the backend response
          'token': responseData['token'], // Optionally pass the token up if needed immediately
          'user': responseData['user'],
          // Optionally pass the user object up
        };
      } else {
        // It's a failure based on status code
        return {
          'success': false,
          'message': serverMessage, // Use the message from the backend response
          'error': httpResponse.body, // Full response for debugging
        };
      }
    } on SocketException catch (e) {
      print('Network error during signup: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your internet connection and server.',
        'error': e.toString(),
      };
    } on FormatException catch (e) {
      print('JSON decoding error during signup: $e');
      return {
        'success': false,
        'message': 'Invalid data received from server.',
        'error': e.toString(),
      };
    } catch (e) {
      print('An unexpected error occurred during signup: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred during signup.',
        'error': e.toString(),
      };
    }
  }

// --- NEW getCurrentMedications method ---
  Future<List<Medication>> getCurrentMedications() async {
    final String? token = await getToken();
    if (token == null) {
      print('Authentication token is not available for current medications. User is likely not logged in.');
      throw Exception('Authentication required to fetch current medications.');
    }

    // The API endpoint you provided
    final url = Uri.parse('$baseUrl/api/prescription-drug/patient/me');

    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Good practice to include
        },
      );

      if (response.statusCode == 200) {
        // Log the raw response for debugging
        print('Current Medications API Response (${response.statusCode}):');
        print(response.body);

        // Decode the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Map the list of JSON objects to a list of Medication objects
        return data.map((json) => Medication.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Handle non-200 status codes
        print('API Error (Current Medications): ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load current medications: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or JSON decoding errors
      print('Error fetching current medications: $e');
      throw Exception('Failed to connect to the server or parse current medications data: $e');
    }
  }



////get all prescriptions
  /// Fetches all prescriptions for the current patient from the API.
  Future<List<Prescription>> getPrescriptions() async {
    final String? token = await getToken();
    if (token == null) {
      print('Authentication token is not available. User is likely not logged in.');
      throw Exception('Authentication required.');
    }

    print('DEBUG: Token being sent: $token'); // <--- ADD THIS LINE
    print('DEBUG: Requesting URL: $baseUrl/api/prescription/patient/me'); // <--- ADD THIS LINE

    final url = Uri.parse('$baseUrl/api/prescription/patient/me');

    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Prescription.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        print('API Error (Get Prescriptions): ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load prescriptions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching prescriptions: $e');
      throw Exception('Failed to connect to the server or parse data: $e');
    }
  }



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
        print('/////////////////hi vitals');
        print(response.body);

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
        print('hi all doctors');
        print(response.body);
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

  ////////////////Doctor details
  // Fetch Doctor Details
  Future<GeneralDoctor> fetchDoctorDetails(int doctorId) async {
    final token = await getToken();
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/auth/doctors/$doctorId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return GeneralDoctor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load doctor details: ${response.statusCode}');
    }
  }
//////////////////doctor map
  Future<String> fetchDoctorMapUrl(int doctorId) async {
    final token = await getToken();
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/auth/$doctorId/coordinates/embed'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      // Assuming the API returns the URL directly in the response body
      return response.body;
    } else {
      throw Exception('Failed to load doctor map URL: ${response.statusCode}');
    }
  }
/////////////////mysaved details
  // Generic function to handle API requests
  Future<List<dynamic>?> fetchData(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final token = await getToken(); // Get the token here
    if (token == null) {
      throw Exception('Token is null. User not authenticated.');
    }
    try {
      final response = await _httpClient.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data =
        json.decode(response.body) as List<dynamic>;
        return data;
      } else {
        print(
            'Failed to fetch data from $endpoint: ${response.statusCode}, body: ${response.body}');
        return null; // Important: Return null for error handling
      }
    } catch (e) {
      print('Error fetching data from $endpoint: $e');
      return null; // Important: Return null for error handling
    }
  }

  // Fetch saved doctors
  Future<List<SavedDoctorModel>?> getSavedDoctors() async {
    final data = await fetchData('/patient/saved/doctor');
    if (data == null) return null;
    return data.map((json) => SavedDoctorModel.fromJson(json)).toList();
  }

  // Fetch saved pharmacies
  Future<List<PharmacyModel>?> getSavedPharmacies() async {
    final data = await fetchData('/patient/saved/pharmacy');
    if (data == null) return null;
    return data.map((json) => PharmacyModel.fromJson(json)).toList();
  }

  // Fetch saved laboratories
  Future<List<SavedLaboratoryModel>?> getSavedLaboratories() async {
    final data = await fetchData('/patient/saved/laboratory');
    if (data == null) return null;
    return data.map((json) => SavedLaboratoryModel.fromJson(json)).toList();
  }


  // New method to remove a saved doctor
  Future<void> removeSavedDoctor(int doctorId) async {
    final url = Uri.parse('$baseUrl/patient/saved/doctor'); // No ID in the path
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is null. User not authenticated.');
    }

    try {
      final response = await _httpClient.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // IMPORTANT: Specify content type for JSON body
        },
        body: json.encode({'doctorId': doctorId}), // Encode the doctorId into a JSON body
      );

      if (response.statusCode == 200 || response.statusCode == 204) { // 200 OK or 204 No Content are common for successful deletion
        print('Successfully removed doctor with ID: $doctorId from saved list.');
      } else {
        print('Failed to remove doctor from saved list: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to remove doctor: ${response.body}');
      }
    } catch (e) {
      print('Error removing doctor from saved list: $e');
      throw Exception('Error removing doctor: $e');
    }
  }
/////////////delete saved lab
  Future<void> removeSavedLaboratory(int laboratoryId) async {
    final url = Uri.parse('$baseUrl/patient/saved/laboratory'); // No ID in the path
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is null. User not authenticated.');
    }

    try {
      final response = await _httpClient.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // IMPORTANT: Specify content type for JSON body
        },
        body: json.encode({'laboratoryId': laboratoryId}), // Encode the laboratoryId into a JSON body
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Successfully removed laboratory with ID: $laboratoryId from saved list.');
      } else {
        print('Failed to remove laboratory from saved list: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to remove laboratory: ${response.body}');
      }
    } catch (e) {
      print('Error removing laboratory from saved list: $e');
      throw Exception('Error removing laboratory: $e');
    }
  }


  // Fetch Labs
  Future<List<LabModel>> fetchLabs() async {
    final response = await _httpClient.get(Uri.parse('$baseUrl/labs'));

    if (response.statusCode == 200) {
      print(response.body);

      // Use the correct model here, LabModel
      List<dynamic> body = jsonDecode(response.body);
      //  print("API Response Body: $body");
      return body.map((json) => LabModel.fromJson(json)).toList();
    } else {
      print('hi exception');
      print(response.body);
      throw Exception('Failed to load labs: ${response.statusCode}');
    }
  }

  // Method to fetch a single lab by ID
  Future<LabModel> fetchLabById(int id) async {
    final response = await _httpClient.get(Uri.parse('$baseUrl/labs/$id'));
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> body = jsonDecode(response.body);
      return LabModel.fromJson(body);
    } else {
      throw Exception('Failed to load lab with ID $id: ${response.statusCode}');
    }
  }
// method to fetch lab embed coordinates for map
  Future<String> fetchLabEmbedCoordinates(int labId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await _httpClient.get(
      Uri.parse('$baseUrl/labs/$labId/coordinates/embed'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.body; // Assuming the response body is the URL string directly
    } else {
      throw Exception('Failed to load map coordinates for lab ID $labId: ${response.statusCode}');
    }
  }

  // New method to fetch lab tests by lab ID
  Future<List<LabTestModel>> fetchLabTests(int labId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final response = await _httpClient.get(
      Uri.parse('$baseUrl/api/lab-tests/lab/$labId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('test body starts here');
      print (response.body);
      print("/////////////testbody ends here");
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => LabTestModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lab tests for lab ID $labId: ${response.statusCode}');
    }
  }
  /// Fetches all Medical Record Entries (MREs) for the current patient from the API.
  Future<List<MedicalRecord>> getMedicalRecords() async {
    final String? token = await getToken();
    if (token == null) {
      print('Authentication token is not available for MREs. User is likely not logged in.');
      throw Exception('Authentication required to fetch medical records.');
    }

    final url = Uri.parse('$baseUrl/mre/patient/me'); // Correct API endpoint

    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MedicalRecord.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        print('API Error (Get Medical Records): ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load medical records: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching medical records: $e');
      throw Exception('Failed to connect to the server or parse medical record data: $e');
    }
  }
/////////////////////////////////////
  Future<List<EmergencyEvent>> fetchEmergencyEvents() async {
    final token = await getToken();
    if (token == null) {

      print('Warning: Token not found. Returning dummy emergency events for testing.');
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    }

    final uri = Uri.parse('$baseUrl/emergencyevents/patient/me');
    try {
      final response = await _httpClient.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => EmergencyEvent.fromJson(json)).toList();
      } else {
        // Handle specific API error responses
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to load emergency events: ${response.statusCode} ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network connection error: $e');
    } on FormatException catch (e) {
      throw Exception('Failed to parse API response: $e');
    } catch (e) {
      throw Exception('An unexpected error occurred while fetching events: $e');
    }
  }

  //////////////////////////////
  Future<MedicalRecordDetails> getMedicalRecordDetails(int mreId) async {
    final String? token = await getToken();
    if (token == null) {
      print('Authentication token is not available for MRE details. User is likely not logged in.');
      throw Exception('Authentication required to fetch medical record details.');
    }

    final url = Uri.parse('$baseUrl/mre/$mreId');

    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('hi from details');
        print('Response Body Length: ${response.body.length}'); // Add this
        print('Raw Response Body: ${response.body}'); // Keep this

        if (response.body.isEmpty) {
          // Handle the case where the body is empty but status is 200
          print('Received 200 OK but response body is empty for MRE ID: $mreId');
          throw Exception('Server returned empty data for medical record details.');
        }

        final Map<String, dynamic> data = json.decode(response.body);
        return MedicalRecordDetails.fromJson(data);
      } else {
        print('API Error (Get MRE Details): ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load medical records: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching medical record details: $e');
      throw Exception('Failed to connect to the server or parse medical record details: $e');
    }
  }

// --- NEW: Save Doctor API Call ---
  Future<void> saveDoctor(int doctorId) async {
    final String? token = await getToken();
    if (token == null) {
      print('Authentication token is not available. User is likely not logged in.');
      throw Exception('Authentication required to save doctor.');
    }

    
    // Use the correct base URL and endpoint provided by the user
    final url = Uri.parse('$baseUrl/patient/saved/doctor');

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'doctorId': doctorId}), // Send doctorId in the body
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 200 OK or 201 Created typically indicate success for POST
        print('Doctor with ID $doctorId saved successfully.');
      } else {
        print('Failed to save doctor with ID $doctorId. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to save doctor: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error saving doctor: $e');
      throw Exception('Failed to connect to server or save doctor: $e');
    }
  }

// NEW: Save Lab
  Future<void> saveLab(int laboratoryId) async {
    final url = Uri.parse('$baseUrl/patient/saved/laboratory');
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is null. User not authenticated.');
    }
    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'laboratoryId': laboratoryId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully saved laboratory with ID: $laboratoryId.');
      } else {
        print('Failed to save laboratory: ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to save laboratory: ${response.body}');
      }
    } catch (e) {
      print('Error saving laboratory: $e');
      throw Exception('Error saving laboratory: $e');
    }
  }


  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
