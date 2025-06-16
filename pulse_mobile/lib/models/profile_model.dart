// lib/models/profile_model.dart
import 'dart:convert'; // Might be needed for some parsing, though not directly used for this fix
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pulse_mobile/services/connections.dart'; // Import your ApiService to get baseUrl

class Profile {
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final List<int>? dateOfBirth; // Or DateTime if you convert it
  final String? placeOfBirth;
  final String? mobileNumber;
  final String? email;
  final String? address;
  final String? password; // Be careful with exposing password
  final String? pictureUrl; // The processed URL
  final String? role;
  final bool? enabled;
  final double? height;
  final double? weight;
  final String? bloodType;
  final String? idImage; // The processed URL
  final String? username;
  final List<dynamic>? authorities; // List of objects/maps
  final bool? accountNonLocked;
  final bool? accountNonExpired;
  final bool? credentialsNonExpired;


  Profile({
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.mobileNumber,
    this.email,
    this.address,
    this.password,
    this.pictureUrl,
    this.role,
    this.enabled,
    this.height,
    this.weight,
    this.bloodType,
    this.idImage,
    this.username,
    this.authorities,
    this.accountNonLocked,
    this.accountNonExpired,
    this.credentialsNonExpired,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    // --- CRITICAL CHANGE HERE ---
    // Ensure ApiService is available globally before calling Get.find()
    // This usually happens in main.dart: Get.put(ApiService());
    final apiService = Get.find<ApiService>();

    const String oldBase = 'https://localhost:8443';
    final String newBase = apiService.baseUrl;

    String? rawPictureUrl = json['pictureUrl'];
    String? rawIdImage = json['idImage'];

    // Add debug prints to see what's happening
    print('DEBUG: Profile.fromJson - rawPictureUrl: $rawPictureUrl');
    print('DEBUG: Profile.fromJson - oldBase: $oldBase');
    print('DEBUG: Profile.fromJson - newBase: $newBase');

    String? processedPictureUrl = rawPictureUrl?.replaceFirst(oldBase, newBase);
    String? processedIdImage = rawIdImage?.replaceFirst(oldBase, newBase);

    print('DEBUG: Profile.fromJson - processedPictureUrl: $processedPictureUrl');
    print('DEBUG: Profile.fromJson - processedIdImage: $processedIdImage');


    return Profile(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null ? List<int>.from(json['dateOfBirth']) : null,
      placeOfBirth: json['placeOfBirth'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      address: json['address'],
      password: json['password'],
      pictureUrl: processedPictureUrl, // Use the processed URL
      role: json['role'],
      enabled: json['enabled'],
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bloodType: json['bloodType'],
      idImage: processedIdImage, // Use the processed URL
      username: json['username'],
      authorities: json['authorities'] != null ? List<dynamic>.from(json['authorities']) : null,
      accountNonLocked: json['accountNonLocked'],
      accountNonExpired: json['accountNonExpired'],
      credentialsNonExpired: json['credentialsNonExpired'],
    );
  }
  // NEW: toJson method for sending data back to the API
  Map<String, dynamic> toJson() {
    // Convert List<int> dateOfBirth back to ISO 8601 string if not null
    String? dobString;
    if (dateOfBirth != null && dateOfBirth!.length == 3) {
      try {
        final dateTime = DateTime(dateOfBirth![0], dateOfBirth![1], dateOfBirth![2]);
        dobString = dateTime.toIso8601String().split('T')[0]; // Format as YYYY-MM-DD
      } catch (e) {
        // Handle invalid dateOfBirth format if necessary
        print('Warning: Could not parse dateOfBirth for toJson: $e');
      }
    }

    return {
      "userId": userId, // Often included for PUT/PATCH requests
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "dateOfBirth": dobString, // Use the formatted string
      "placeOfBirth": placeOfBirth,
      "mobileNumber": mobileNumber,
      "email": email, // Email might be a key field for updates, or read-only
      "address": address,
      "height": height,
      "weight": weight,
      "bloodType": bloodType,
      "pictureUrl": pictureUrl, // Include the fixed URL
      "idImage": idImage,       // Include the fixed URL
      // Do NOT include sensitive fields like 'password' for profile updates
      // Do NOT include backend-managed fields like 'role', 'enabled', 'username',
      // 'authorities', 'accountNonLocked', etc., unless explicitly required by your API for client updates.
    };
  }
// NEW: toUpdateDtoJson method for the 'dto' part of the multipart update request
  Map<String, dynamic> toUpdateDtoJson() {
    return {
      "height": height,
      "weight": weight,
      "bloodType": bloodType,
      // Only include fields that are part of your backend's 'dto' for update
      // Based on your Postman example, it looks like only these three.
      // If firstName, lastName, etc., are also updatable via the 'dto' part, add them here.
    };
  }
}