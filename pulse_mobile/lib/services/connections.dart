import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/response/response.dart' as http_package;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:pulse_mobile/models/mySavedDoctor_model.dart';
import '../models/LabModel.dart';
import '../models/LabResultDeatils.dart';
import '../models/LabResultsModel.dart';
import '../models/allergies.dart';
import '../models/categoryModel.dart';
import '../models/chronic_disease_model.dart';
import '../models/doctor_model_featured_homepage.dart';
import '../models/emergencyEvent.dart';
import '../models/generalDoctorModel.dart';
import '../models/labTestModel.dart';
import '../models/medical_record_details_model.dart';
import '../models/medicalrecordlistitemsModel.dart';
import '../models/medicationModel.dart';
import '../models/mySavedLab_model.dart';
import '../models/mySavedPharmacy_model.dart';
import '../models/pharmacy.dart';
import '../models/prescriptionListitemModel.dart';
import '../models/prescription_details.dart';
import '../models/prescriptionitem.dart';
import '../models/profile_model.dart';
import '../models/signupModel.dart';
import '../models/vitals_model.dart';
import 'dart:developer';
import 'package:http/io_client.dart';

class ApiService extends GetxService {
  final String baseUrl = 'https://192.168.210.222:8443';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _httpClient =
  _createHttpClient(); // Use custom client for HTTPS
  static const String _tokenKey = 'userToken';

  static http.Client _createHttpClient() {
    HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
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

//////////////////////////////
  Future<http.Response> put(String path, {Map<String, dynamic>? queryParams, Map<String, dynamic>? body}) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please log in.');
    }

    Uri uri = Uri.parse('$baseUrl$path');

    // Add query parameters if provided
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())));
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Assuming all PUT requests send JSON
      'Accept': 'application/json',
    };

    try {
      log('API PUT Request: URL: $uri');
      log('Headers: $headers');
      if (body != null) {
        log('Body: ${json.encode(body)}');
      }

      final response = await _httpClient.put(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null, // Encode body to JSON string
      );

      log('API PUT Response Status: ${response.statusCode}');
      log('API PUT Response Body: ${response.body}');

      return response;
    } on http.ClientException catch (e) {
      log('HTTP Client Error during PUT: $e');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Generic Error during PUT: $e');
      rethrow; // Re-throw any other exceptions
    }
  }

  /// Specific method to approve or deny a consent request.
  /// [consentId] - The ID of the consent request.
  /// [decision] - 'APPROVE' or 'DENY'.
  Future<void> updateConsentStatus(int consentId, String decision) async {
    try {
      final response = await put(
        '/api/v1/consents/$consentId', // The endpoint path
        queryParams: {'decision': decision}, // Your query parameter
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Successful response (2xx codes)
        log('Consent ID $consentId $decision successfully.');
        // You can parse response.body if the API returns data on success
      } else {
        // Handle API errors based on status code
        String errorMessage = 'Failed to $decision consent for ID $consentId. Status: ${response.statusCode}';
        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            // Assuming your API returns an 'message' field for errors
            if (errorData.containsKey('message')) {
              errorMessage += ' - ${errorData['message']}';
            }
          } catch (e) {
            log('Could not parse error response body: $e');
          }
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      log('Error in updateConsentStatus: $e');
      rethrow; // Re-throw to be handled by the StompService
    }
  }
/////////////////////



  // Authentication Services
  Future<bool> login(String email, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
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
        final String? message = body['message']; // Get the message from the response

        // --- CORRECTED LOGIC HERE ---
        // If the message explicitly indicates OTP sent, it's a success leading to 2FA
        if (message != null && message.contains("OTP sent to your email")) {
          print('OTP sent, proceeding to 2FA verification.');
          // The userId (if available) can be passed here if needed by TwoFactorController arguments,
          // but email is sufficient as per current 2FA API spec.
          return true; // Indicate success for navigation to 2FA
        }
        else {
          // Status 200, but no 'OTP sent' message and no token (unexpected for this flow)
          print('Login response 200 but no OTP message or token. Assuming login failed or unexpected scenario.');
          return false;
        }
      } else {
        // Handle non-200 status codes (e.g., 401 Unauthorized, 400 Bad Request)
        String errorMessage = 'Login failed: ${response.statusCode}';
        try {
          final Map<String, dynamic> errorBody = jsonDecode(response.body);
          if (errorBody.containsKey('message')) {
            errorMessage = errorBody['message'];
          }
        } catch (e) {
          // If body is not JSON or message field is missing
        }
        print('Login failed: ${response.statusCode} - $errorMessage');
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


  // --- NEW: Dedicated 2FA Verification Method ---
  Future<Profile> postTwoFactorVerification(String email, String otp) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/login/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      print('HTTP Status Code (2FA Verify OTP): ${response.statusCode}');
      print('Response Body (2FA Verify OTP): ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final Profile profile = Profile.fromJson(body);

        // Assuming the 2FA response also contains the token
        // You might need to adjust the backend response to include the token directly
        // in the root of the JSON if it's not nested within the Profile data.
        final String? token = body['token']; // Assuming 'token' is a top-level key in the response

        if (token != null) {
          await saveToken(token);
          print('Token saved after 2FA verification.');
        } else {
          print('2FA successful, but no new token found in response. This might be an issue.');
        }
        return profile; // Return the full profile
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        final String errorMessage = errorBody['message'] ?? 'OTP verification failed.';
        print('2FA verification failed: ${response.statusCode} - $errorMessage');
        throw Exception(errorMessage);
      }
    } on SocketException catch (e) {
      print('Network error during 2FA verification: $e');
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException catch (e) {
      print('JSON decoding error during 2FA verification: $e');
      throw Exception('Failed to process server response.');
    } catch (e) {
      print('An unexpected error occurred during 2FA verification: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

////////////////////////////////
  Future<void> sendOtpByEmail(String email) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email},
    );
    print('sendOtpByEmail response: ${response.body}'); // For debugging

    if (response.statusCode == 200) {
      print('OTP sent to email: $email'); // Success message in terminal
    } else {
      String errorMessage = 'Failed to send OTP to email.';
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        if (errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        }
      } catch (e) {
        // Fallback if response body is not valid JSON
      }
      print('Error sending OTP: $errorMessage'); // Error message in terminal
      // Optionally re-throw the error if you want the calling controller to handle it explicitly
      // throw Exception(errorMessage);
    }
  }

  /// Reset Password (now implicitly handles OTP verification)
  Future<void> resetPassword(String email, String otp, String newPassword) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl/auth/reset'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      },
    );
    print('resetPassword response: ${response.body}'); // For debugging

    if (response.statusCode == 200) {
      print('Password reset successfully for email: $email'); // Success message in terminal
    } else {
      String errorMessage = 'Failed to reset password.';
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        if (errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        }
      } catch (e) {
        // Fallback if response body is not valid JSON
      }
      print('Error resetting password: $errorMessage'); // Error message in terminal
      // Optionally re-throw the error if you want the calling controller to handle it explicitly
      // throw Exception(errorMessage);
    }
  }
/////////////////////////////
  Future<bool> validateToken() async {
    final String? token = await getToken();
    if (token == null) {
      return false;
    }
    final response = await _httpClient.get(
      Uri.parse('$baseUrl/api/validate-token'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
  // User Profile Services
  ////get profile
  // User Profile Services (inside your ApiService class)
  Future<Profile> getUserProfile() async {
    final String? token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    final url = Uri.parse('$baseUrl/auth/profile/patient');
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = json.decode(response.body);

        // --- CRITICAL CHANGE HERE ---
        // Pass the 'user' sub-map to Profile.fromJson
        if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
          return Profile.fromJson(data['user'] as Map<String, dynamic>);
        } else {
          throw Exception('User data not found or malformed in response.');
        }
      } else {
        // Handle different error codes more specifically
        throw Exception(
            'Failed to fetch profile: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  /// Fetches the user profile data.
  Future<Profile> getUserProfileEdit() async {
    final String? token = await getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    final url = Uri.parse('$baseUrl/auth/profile/patient');
    try {
      final response = await _httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final Map<String, dynamic> data = json.decode(response.body);

        // --- CRITICAL CHANGE HERE ---
        // Pass the 'user' sub-map to Profile.fromJson
        if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
          return Profile.fromJson(data['user'] as Map<String, dynamic>);
        } else {
          throw Exception('User data not found or malformed in response.');
        }
      } else {
        // Handle different error codes more specifically
        throw Exception(
            'Failed to fetch profile: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  /// Updates the user profile data using multipart/form-data.
  Future<void> updateUserProfile(Profile updatedProfileData, {File? newProfilePicture}) async {
    final String? token = await getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User token is null or empty. Cannot update profile.');
    }
    final url = Uri.parse('$baseUrl/auth/update/patient');

    try {
      final request = http.MultipartRequest('PUT', url); // Use PUT for update
      request.headers['Authorization'] = 'Bearer $token'; // Add Authorization header

      // --- Add the 'dto' part (JSON data) ---
      final Map<String, dynamic> updateDto = updatedProfileData.toUpdateDtoJson();
      print('DEBUG: Update DTO JSON: ${jsonEncode(updateDto)}'); // Debug print
      request.files.add(http.MultipartFile.fromString(
        'dto', // Backend expects 'dto' as the field name for JSON
        jsonEncode(updateDto),
        contentType: MediaType('application', 'json'),
      ));

      // --- Add the 'profile_picture' file if provided ---
      if (newProfilePicture != null) {
        print('DEBUG: Attempting to add profile_picture file from path: ${newProfilePicture.path}');
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', // Backend expects 'profile_picture' as the field name for the file
          newProfilePicture.path,
          // Let fromPath infer content type, similar to signup
        ));
      }

      final streamedResponse = await _httpClient.send(request);
      final httpResponse = await http.Response.fromStream(streamedResponse);

      print('HTTP Status Code (Update Profile): ${httpResponse.statusCode}');
      print('Response Body (Update Profile): ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        print('Profile updated successfully!');
      } else {
        throw Exception(
            'Failed to update profile: ${httpResponse.statusCode}, ${httpResponse.body}');
      }
    } on SocketException catch (e) {
      print('Network error during profile update: $e');
      throw Exception('Network error. Please check your internet connection: $e');
    } catch (e) {
      print('An unexpected error occurred during profile update: $e');
      rethrow;
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
  ////////////
  Future<Map<String, dynamic>> signUp(SignupUserModel user) async {
    final url = Uri.parse('$baseUrl/auth/register/patient');

    try {
      final request = http.MultipartRequest('POST', url);

      // --- CRITICAL CHANGE: Send 'data' as application/json ---
      // This ensures your JSON user data is sent with the correct content type.
      request.files.add(http.MultipartFile.fromString(
        'data',
        jsonEncode(user.toJson()), // User data as JSON string
        contentType: MediaType('application', 'json'), // Set content type for JSON part
      ));

      // Add the 'picture' file if it exists
      if (user.pictureFile != null) {
        print('DEBUG: Attempting to add picture file from path: ${user.pictureFile!.path}');
        // Using http.MultipartFile.fromPath without explicit contentType
        // This will let the http package try to infer the content type.
        request.files.add(await http.MultipartFile.fromPath(
          'picture',
          user.pictureFile!.path,
        ));
      }

      // Add the 'idImage' file if it exists
      if (user.idImageFile != null) {
        print('DEBUG: Attempting to add ID image file from path: ${user.idImageFile!.path}');
        // Using http.MultipartFile.fromPath without explicit contentType
        // This will let the http package try to infer the content type.
        request.files.add(await http.MultipartFile.fromPath(
          'idImage',
          user.idImageFile!.path,
        ));
      }

      final streamedResponse = await _httpClient.send(request);
      final httpResponse = await http.Response.fromStream(streamedResponse);

      print('HTTP Status Code (Signup): ${httpResponse.statusCode}');
      print('Response Body (Signup): ${httpResponse.body}');

      Map<String, dynamic> responseData;
      String serverMessage;

      if (httpResponse.body.isNotEmpty) {
        try {
          responseData = json.decode(httpResponse.body);
          serverMessage = responseData['message'] ?? responseData['error'] ?? 'Server responded without a specific message.';
        } on FormatException catch (e) {
          print('Error decoding JSON, raw body content: ${httpResponse.body}. Error: $e');
          responseData = {};
          serverMessage = 'Server returned status ${httpResponse.statusCode} with malformed body: ${httpResponse.body}';
        } catch (e) {
          print('Unexpected error during JSON decoding: $e. Raw body content: ${httpResponse.body}');
          responseData = {};
          serverMessage = 'Server returned status ${httpResponse.statusCode} with unexpected body: ${httpResponse.body}';
        }
      } else {
        responseData = {};
        serverMessage = 'Server returned status ${httpResponse.statusCode} with an empty response body.';
        if (httpResponse.statusCode == 403) {
          serverMessage = 'Access Forbidden: The server provided an empty response body. Check backend logs for CORS/CSRF/Permissions.';
        }
      }

      if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
        return {
          'success': true,
          'message': serverMessage,
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        return {
          'success': false,
          'message': serverMessage,
          'error': httpResponse.body,
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
      print('Outer JSON decoding error during signup: $e');
      return {
        'success': false,
        'message': 'Invalid data received from server (outer catch).',
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
  //////////////////////
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
    // Retrieve the token from secure storage
    String? token = await getToken();

    // Ensure the token is available. If not, handle the error (e.g., throw exception, redirect to login).
    if (token == null || token.isEmpty) {
      print('ERROR: Authentication token is missing or empty.');
      throw Exception('Authentication token is required to fetch labs.');
    }


    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Use the retrieved token
    };

    print('DEBUG: Requesting GET $baseUrl/labs with headers: $headers');

    final response = await _httpClient.get(
      Uri.parse('$baseUrl/labs'),
      headers: headers, // Pass the headers map to the request
    );

    if (response.statusCode == 200) {
      print('DEBUG: Successfully fetched labs. Response body length: ${response.body.length}');
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => LabModel.fromJson(json)).toList();
    } else {
      print('ERROR: Failed to load labs. Status code: ${response.statusCode}');
      print('ERROR: Response body: ${response.body}');
      throw Exception('Failed to load labs: ${response.statusCode}');
    }
  }

  // Method to fetch a single lab by ID
  Future<LabModel> fetchLabById(int id) async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      print('ERROR: Authentication token is missing or empty for fetchLabById.');
      throw Exception('Authentication token is required to fetch a lab by ID.');
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the bearer token
    };

    print('DEBUG: Requesting GET $baseUrl/labs/$id with headers: $headers');

    final response = await _httpClient.get(
      Uri.parse('$baseUrl/labs/$id'),
      headers: headers, // Pass the headers map
    );

    if (response.statusCode == 200) {
      print('DEBUG: Successfully fetched lab by ID $id. Response body length: ${response.body.length}');
      Map<String, dynamic> body = jsonDecode(response.body);
      return LabModel.fromJson(body);
    } else {
      print('ERROR: Failed to load lab with ID $id. Status code: ${response.statusCode}');
      print('ERROR: Response body: ${response.body}');
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
      return response.body;
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

    final url = Uri.parse('$baseUrl/mre/patient/me');

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
        print('Response Body Length: ${response.body.length}');
        print('Raw Response Body: ${response.body}');

        if (response.body.isEmpty) {
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

    
    final url = Uri.parse('$baseUrl/patient/saved/doctor');

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'doctorId': doctorId}),
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
  // New getLabResults method
  Future<List<LabResultListItem>> getLabResults() async {
    final String? token = await getToken();
    if (token == null) {
      print(
          'Authentication token is not available for Lab Results. User is likely not logged in.');
      throw Exception('Authentication required to fetch lab results.');
    }

    final url = Uri.parse(
        '$baseUrl/api/lab-results/patient/me');

    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',

        },
      );

      if (response.statusCode == 200) {
        print (response.body);
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) =>
            LabResultListItem.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        print('API Error (Get Lab Results): ${response.statusCode} - ${response
            .body}');
        throw Exception('Failed to load lab results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching lab results: $e');
      throw Exception(
          'Failed to connect to the server or parse lab results data: $e');
    }
  }


  Future<LabResultDetails> getLabResultDetails(int labResultId) async {
    final String? token = await getToken();
    if (token == null) {
      print('Authentication token is not available for Lab Results Details. User is likely not logged in.');
      throw Exception('Authentication required to fetch lab results details.');
    }

    final url = Uri.parse('$baseUrl/api/lab-results/$labResultId');

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
        if (response.body.isNotEmpty) {
          final Map<String, dynamic> data = json.decode(response.body);
          return LabResultDetails.fromJson(data);
        } else {
          throw Exception('Empty response body for lab result details.');
        }
      } else {
        print('API Error (Get Lab Result Details): ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load lab result details for ID $labResultId: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching lab result details for ID $labResultId: $e');
      rethrow;
    }
  }
  /////////////////qr code

  Future<bool> postConsentForDoctor(int doctorId) async {
    final String? token = await getToken();
    if (token == null) {
      print('Authorization token not found.');
      throw Exception('Authorization token not found.');
    }

    final Uri uri = Uri.parse('$baseUrl/api/v1/consents/doctor/$doctorId');

    try {
      final http.Response response = await _httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Consent API call successful for doctor ID: $doctorId');
        print(response.statusCode);

        print('Response: ${response.body}');
        return true;
      } else {
        print('Consent API call failed for doctor ID: $doctorId. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to send consent. Status code: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error during consent API call: $e');
      rethrow; // Re-throw the exception for the controller to catch
    }
  }
  /// Fetches details for a single prescription by ID.
  /// This method now processes a LIST of prescription-drug line items to build one PrescriptionDetailsInfo.
  Future<PrescriptionDetailsInfo?> getPrescription(int id) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      final response = await _httpClient.get(
        Uri.parse('$baseUrl/api/prescription-drug/prescription/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('hello prescription details (raw response):');
        print(response.body);

        final dynamic decodedResponse = json.decode(response.body);

        if (decodedResponse is List && decodedResponse.isNotEmpty) {

          // 1. Get overall prescription details from the FIRST item in the list
          final Map<String, dynamic> firstLineItemJson = decodedResponse[0];
          PrescriptionDetailsInfo prescriptionDetails = PrescriptionDetailsInfo.fromPrescriptionJson(firstLineItemJson);

          // 2. Build the list of PrescriptionLineItem (medications) from ALL items in the list
          List<PrescriptionLineItem> lineItems = [];
          for (var itemJson in decodedResponse) {
            if (itemJson is Map<String, dynamic>) {
              lineItems.add(PrescriptionLineItem.fromJson(itemJson));
            }
          }

          // 3. Assign the collected line items to the prescriptionDetails object
          return prescriptionDetails.copyWith(medications: lineItems);

        } else {
          // Handle cases where the response is empty or not a list as expected
          print('Unexpected empty or malformed response for prescription ID $id: $decodedResponse');
          return null;
        }
      } else if (response.statusCode == 404) {
        print('Prescription with ID $id not found.');
        return null;
      } else {
        print('Failed to load prescription: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching prescription details for ID $id: $e');
      return null;
    }

  }
  ///////////////pharmacies
// Method to fetch list of pharmacies
  Future<List<PharmacylistModel>> fetchPharmacies() async {
    try {
      final String? token = await getToken();

      if (token == null || token.isEmpty) {
        print('ERROR: Authentication token is missing or empty for fetchPharmacies.');
        throw Exception('Authentication token is required to fetch pharmacies.');
      }

      final url = Uri.parse('$baseUrl/pharmacies');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the bearer token
      };

      print('DEBUG: Requesting GET $baseUrl/pharmacies with headers: $headers');

      // Make the HTTP GET request.
      final response = await _httpClient.get(url, headers: headers);

      if (response.statusCode == 200) {
        print('DEBUG: Successfully fetched pharmacies. Response body length: ${response.body.length}');
        // Parse the JSON response body into a list of PharmacyModel objects.
        return parsePharmacies(response.body); // Assuming parsePharmacies is a helper function
      } else {
        print('ERROR: Failed to load pharmacies: ${response.statusCode} ${response.body}');
        throw Exception('Failed to load pharmacies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pharmacies: $e');
      throw Exception('Error fetching pharmacies: $e');
    }
  }

  // Method to fetch pharmacy details by ID
  Future<PharmacylistModel> fetchPharmacyDetails(int pharmacyId) async {
    final String? token = await getToken();

    if (token == null || token.isEmpty) {
      print('ERROR: Authentication token is missing or empty for fetchPharmacyDetails.');
      throw Exception('Authentication token is required to fetch pharmacy details.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the bearer token
    };

    print('DEBUG: Requesting GET $baseUrl/pharmacies/$pharmacyId with headers: $headers');

    final response = await _httpClient.get( // Use _httpClient instead of http.get
      Uri.parse('$baseUrl/pharmacies/$pharmacyId'),
      headers: headers, // Pass the headers map
    );

    if (response.statusCode == 200) {
      print('DEBUG: Successfully fetched pharmacy details for ID $pharmacyId. Response body length: ${response.body.length}');
      return PharmacylistModel.fromJson(json.decode(response.body));
    } else {
      print('ERROR: Failed to load pharmacy details for ID: $pharmacyId (Status: ${response.statusCode})');
      print('ERROR: Response body: ${response.body}');
      throw Exception('Failed to load pharmacy details for ID: $pharmacyId (Status: ${response.statusCode})');
    }
  }



////////////chronic
  // --- New Chronic Disease Method ---
  Future<List<ChronicDiseaseModel>> fetchChronicDiseases() async {
    final String? token = await getToken();

    if (token == null) {
      throw Exception('Authentication token is missing. Please log in.');
    }

    // Define the headers, including the Authorization token
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await _httpClient.get(
      Uri.parse('$baseUrl/testing/patient-chronic-diseases/me'),
      headers: headers, // Pass the headers with the request
    );

    if (response.statusCode == 200) {
      return parseChronicDiseases(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Handle unauthorized or forbidden access specifically
      throw Exception('Authentication failed or unauthorized access. Please log in again.');
    } else {
      throw Exception('Failed to load chronic diseases: ${response.statusCode} - ${response.body}');
    }
  }

  // NEW: Method to fetch allergies
  Future<List<AllergyModel>> fetchAllergies() async {
    final String? token = await getToken();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };


    final response = await _httpClient.get(Uri.parse('$baseUrl/testing/patient-allergies/me'), headers: headers);

    if (response.statusCode == 200) {
      // Decode the JSON response body
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AllergyModel.fromJson(json)).toList();

    } else {
      // Handle different error status codes if needed
      throw Exception('Failed to load allergies: ${response.statusCode}');
    }
  }
/////////////////////pharmacymap
  Future<String> fetchPharmacyMapUrl(int pharmacyId) async {

    final token = await getToken();

    final response = await _httpClient.get(
      Uri.parse('$baseUrl/pharmacies/$pharmacyId/coordinates/embed'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // The API returns the URL directly in the response body as plain text.
      return response.body;
    } else {
      throw Exception('Failed to load pharmacy map URL: ${response.statusCode} ${response.body}');
    }
  }
// --- NEW: Saved Pharmacy API Calls ---


  /// Saves a pharmacy to the user's saved list.
  Future<void> savePharmacy(int pharmacyId) async {
    final String? token = await getToken();
    if (token == null || token.isEmpty) {
      print('Authentication token is not available. User is likely not logged in.');
      throw Exception('Authentication required to save pharmacy.');
    }

    final url = Uri.parse('$baseUrl/patient/saved/pharmacy');

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'pharmacyId': pharmacyId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('DEBUG: Pharmacy with ID $pharmacyId saved successfully.');
      } else {
        print('Failed to save pharmacy with ID $pharmacyId. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to save pharmacy: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error saving pharmacy: $e');
      throw Exception('Failed to connect to server or save pharmacy: $e');
    }
  }

  /// Removes a pharmacy from the user's saved list.
  Future<void> removeSavedPharmacy(int pharmacyId) async {
    final String? token = await getToken();
    if (token == null || token.isEmpty) {
      print('Authentication token is not available. User is likely not logged in.');
      throw Exception('Authentication required to remove saved pharmacy.');
    }

    final url = Uri.parse('$baseUrl/patient/saved/pharmacy'); // Endpoint for deletion

    try {
      final response = await _httpClient.delete( // Use DELETE method
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'pharmacyId': pharmacyId}), // Body for DELETE request
      );

      if (response.statusCode == 200 || response.statusCode == 204) { // 200 OK or 204 No Content for successful deletion
        print('DEBUG: Pharmacy with ID $pharmacyId removed successfully.');
      } else {
        print('Failed to remove pharmacy with ID $pharmacyId. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to remove pharmacy: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error removing pharmacy: $e');
      throw Exception('Failed to connect to server or remove pharmacy: $e');
    }
  }

  @override
  void onClose() {
    _httpClient.close();
    super.onClose();
  }
}
