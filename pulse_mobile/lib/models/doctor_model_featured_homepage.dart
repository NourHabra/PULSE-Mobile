// lib/models/featured_doctor.dart
import 'package:get/get.dart'; // Import Get for dependency injection
import 'package:pulse_mobile/services/connections.dart'; // Import your ApiService

class FeaturedDoctor {
  final int id;
  final String fullName;
  final String pictureUrl;
  final String specialization;
  final String? coordinates;

  FeaturedDoctor({
    required this.id,
    required this.fullName,
    required this.pictureUrl,
    required this.specialization,
    this.coordinates,

  });

  factory FeaturedDoctor.fromJson(Map<String, dynamic> json) {
    // Ensure ApiService is available globally before calling Get.find()
    // This usually happens in main.dart or your app's binding setup: Get.put(ApiService());
    final apiService = Get.find<ApiService>();

    const String oldBase = 'https://localhost:8443'; // The old base URL from the backend
    final String newBase = apiService.baseUrl; // The new base URL from your ApiService

    String? rawPictureUrl = json['pictureUrl'];

    // --- Image URL Handling Mimicking Profile Model ---
    // Add debug prints to see what's happening
    print('DEBUG: FeaturedDoctor.fromJson - rawPictureUrl: $rawPictureUrl');
    print('DEBUG: FeaturedDoctor.fromJson - oldBase: $oldBase');
    print('DEBUG: FeaturedDoctor.fromJson - newBase: $newBase');

    String processedPictureUrl = rawPictureUrl?.replaceFirst(oldBase, newBase) ?? ''; // Replace old base with new
    // If rawPictureUrl is null, processedPictureUrl will be an empty string,
    // which is generally safer than null for required image URLs.
    // Adjust this default value if you prefer a placeholder or actual null.

    print('DEBUG: FeaturedDoctor.fromJson - processedPictureUrl: $processedPictureUrl');

    return FeaturedDoctor(
      id: json['id'],
      fullName: json['fullName'],
      pictureUrl: processedPictureUrl, // Use the processed URL
      specialization: json['specialization'],
      coordinates: json['coordinates'],
    );
  }

  @override
  String toString() {
    return 'FeaturedDoctor{id: $id, fullName: $fullName, pictureUrl: $pictureUrl, specialization: $specialization, coordinates: $coordinates}';
  }
}
