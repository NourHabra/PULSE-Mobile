import 'package:intl/intl.dart';

class GeneralDoctor2 {
  final int id; // This is a non-nullable int
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
  final String? pictureUrl;
  final String? coordinates;

  GeneralDoctor2({
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

  factory GeneralDoctor2.fromJson(Map<String, dynamic> json) {
    return GeneralDoctor2(
      id: json['userId'] as int, // <-- CHANGED: Map 'userId' from JSON to 'id' field
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      specialization: json['specialization'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      workingHours: json['workingHours'] as String?,
      biography: json['biography'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: (json['dateOfBirth'] as List?)?.cast<int>(),
      placeOfBirth: json['placeOfBirth'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      address: json['address'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
      coordinates: json['coordinates'] as String?,
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
