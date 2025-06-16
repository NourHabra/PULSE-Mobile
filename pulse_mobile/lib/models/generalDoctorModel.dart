// lib/models/general_doctor.dart
import 'package:get/get.dart'; // Import Get for dependency injection
import 'package:pulse_mobile/services/connections.dart'; // Import your ApiService

class GeneralDoctor {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? specialization;
  final String? licenseNumber;
  final String? workingHours;
  final String? biography;
  final String? gender;
  final List<int>? dateOfBirth;
  final String? placeOfBirth;
  final String? mobileNumber;
  final String? address;
  final String? pictureUrl; // This will now be the processed URL
  final String? coordinates;

  GeneralDoctor({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.specialization,
    this.licenseNumber,
    this.workingHours,
    this.biography,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.mobileNumber,
    this.address,
    this.pictureUrl,
    this.coordinates,
  });

  factory GeneralDoctor.fromJson(Map<String, dynamic> json) {
    // Ensure ApiService is available globally before calling Get.find()
    // This usually happens in main.dart or your app's binding setup: Get.put(ApiService());
    final apiService = Get.find<ApiService>();

    const String oldBase = 'https://localhost:8443'; // The old base URL from the backend
    final String newBase = apiService.baseUrl; // The new base URL from your ApiService

    String? rawPictureUrl = json['pictureUrl'];

    // --- Image URL Handling Mimicking Profile Model ---
    // Add debug prints to see what's happening
    print('DEBUG: GeneralDoctor.fromJson - rawPictureUrl: $rawPictureUrl');
    print('DEBUG: GeneralDoctor.fromJson - oldBase: $oldBase');
    print('DEBUG: GeneralDoctor.fromJson - newBase: $newBase');

    // Replace the old base URL with the new one. If rawPictureUrl is null, the result will also be null.
    String? processedPictureUrl = rawPictureUrl?.replaceFirst(oldBase, newBase);

    print('DEBUG: GeneralDoctor.fromJson - processedPictureUrl: $processedPictureUrl');


    return GeneralDoctor(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      workingHours: json['workingHours'],
      biography: json['biography'],
      gender: json['gender'],
      dateOfBirth: (json['dateOfBirth'] as List?)?.cast<int>(),
      placeOfBirth: json['placeOfBirth'],
      mobileNumber: json['mobileNumber'],
      address: json['address'],
      pictureUrl: processedPictureUrl, // Use the processed URL
      coordinates: json['coordinates'],
    );
  }


  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
