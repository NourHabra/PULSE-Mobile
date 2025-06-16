// lib/models/pharmacy_model.dart

import 'dart:convert';

// Define the PharmacyModel class to represent a single pharmacy's data.
class PharmacylistModel {
  final int pharmacyId;
  final String name;
  final String? licenseNumber; // Nullable as per your API example
  final String? workingHours; // Nullable as per your API example
  final String? manager; // Nullable as per your API example
  final String phone; // Nullable as per your API example
  final String address;
  final String? locationCoordinates;

  var pictureUrl; // Nullable as per your API example

  // Constructor for the PharmacyModel.
  PharmacylistModel({
    required this.pharmacyId,
    required this.name,
    this.licenseNumber,
    this.workingHours,
    this.manager,
    required this.phone,
    required this.address,
    this.locationCoordinates,
  });

  // Factory constructor to create a PharmacyModel instance from a JSON map.
  factory PharmacylistModel.fromJson(Map<String, dynamic> json) {
    return PharmacylistModel(
      pharmacyId: json['pharmacyId'] as int,
      name: json['name'] as String,
      licenseNumber: json['licenseNumber'] as String?,
      workingHours: json['workingHours'] as String?,
      manager: json['manager'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String,
      locationCoordinates: json['locationCoordinates'] as String?,
    );
  }

  // Method to convert a PharmacyModel instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'pharmacyId': pharmacyId,
      'name': name,
      'licenseNumber': licenseNumber,
      'workingHours': workingHours,
      'manager': manager,
      'phone': phone,
      'address': address,
      'locationCoordinates': locationCoordinates,
    };
  }

  // Optional: Add a copyWith method for immutability and easy updates.
  PharmacylistModel copyWith({
    int? pharmacyId,
    String? name,
    String? licenseNumber,
    String? workingHours,
    String? manager,
    String? phone,
    String? address,
    String? locationCoordinates,
  }) {
    return PharmacylistModel(
      pharmacyId: pharmacyId ?? this.pharmacyId,
      name: name ?? this.name,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      workingHours: workingHours ?? this.workingHours,
      manager: manager ?? this.manager,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      locationCoordinates: locationCoordinates ?? this.locationCoordinates,
    );
  }
}

// Helper function to parse a list of JSON objects into a list of PharmacyModel.
List<PharmacylistModel> parsePharmacies(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<PharmacylistModel>((json) => PharmacylistModel.fromJson(json))
      .toList();
}
