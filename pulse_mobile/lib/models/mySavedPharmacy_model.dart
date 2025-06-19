import 'package:get/get.dart';
import 'package:pulse_mobile/services/connections.dart';

class PharmacyModel {
  final int id;
  final String name;
  final String address;
  final String? pictureUrl;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    this.pictureUrl,
  });

  
  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    // Access the nested 'pharmacy' object
    final Map<String, dynamic> pharmacyData = json['pharmacy'];

    // Ensure ApiService is available globally before calling Get.find()
    final apiService = Get.find<ApiService>();

    const String oldBase = 'https://localhost:8443'; // The old base URL from the backend
    final String newBase = apiService.baseUrl;

    String? rawPictureUrl = pharmacyData['pictureUrl'] as String?; // Get the pictureUrl from pharmacyData

    // --- Image URL Handling Mimicking FeaturedDoctor Model ---
    print('DEBUG: PharmacyModel.fromJson - rawPictureUrl: $rawPictureUrl');
    print('DEBUG: PharmacyModel.fromJson - oldBase: $oldBase');
    print('DEBUG: PharmacyModel.fromJson - newBase: $newBase');

    String? finalPictureUrl;

    // First, try to process the URL from the API if it exists and is not empty
    if (rawPictureUrl != null && rawPictureUrl.isNotEmpty) {
      finalPictureUrl = rawPictureUrl.replaceFirst(oldBase, newBase);
    }

    // If after processing, the URL is still null or empty, use the asset path as a fallback
    if (finalPictureUrl == null || finalPictureUrl.isEmpty) {
      finalPictureUrl = 'assets/pill_600dp.png';
    }

    print('DEBUG: PharmacyModel.fromJson - finalPictureUrl: $finalPictureUrl');

    return PharmacyModel(
      id: pharmacyData['pharmacyId'] as int, // Correctly access pharmacyId
      name: pharmacyData['name'] as String,
      address: pharmacyData['address'] as String,
      pictureUrl: finalPictureUrl, // Use the final processed or asset URL
    );
  }
}
