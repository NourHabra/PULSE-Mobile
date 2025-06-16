import 'package:intl/intl.dart';
import 'dart:developer'; // Import for log

class TechnicianModel {
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? placeOfBirth;
  final String? mobileNumber;
  final String? email;
  final String? address;
  final String? password;
  final String? pictureUrl;
  final String? role;
  final bool? enabled;
  final String? licenseNumber;
  final String? technicianRole;
  final String? username;
  final int? laboratoryId;

  TechnicianModel({
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
    this.licenseNumber,
    this.technicianRole,
    this.username,
    this.laboratoryId,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    log('TechnicianModel.fromJson received JSON: $json');

    // Check parsing of userId and laboratoryId
    log('Attempting to parse userId. Value in JSON: ${json['userId']}');
    final int? parsedUserId = json['userId'] as int?;
    log('Parsed userId: $parsedUserId');

    log('Attempting to parse laboratoryId. Value in JSON: ${json['laboratoryId']}');
    final int? parsedLaboratoryId = json['laboratoryId'] as int?;
    log('Parsed laboratoryId: $parsedLaboratoryId');

    DateTime? parsedDateOfBirth;
    if (json['dateOfBirth'] is List) {
      List<int> dobList = List<int>.from(json['dateOfBirth']);
      if (dobList.length >= 3) {
        try {
          parsedDateOfBirth = DateTime(dobList[0], dobList[1], dobList[2]);
        } catch (e) {
          log('Error parsing TechnicianModel dateOfBirth list: $e'); // Use log for errors too
        }
      }
    } else if (json['dateOfBirth'] is String && json['dateOfBirth'].isNotEmpty) {
      try {
        parsedDateOfBirth = DateTime.parse(json['dateOfBirth'] as String);
      } catch (e) {
        log('Error parsing TechnicianModel dateOfBirth string: $e');
      }
    }

    return TechnicianModel(
      userId: parsedUserId,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: parsedDateOfBirth,
      placeOfBirth: json['placeOfBirth'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      password: json['password'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
      role: json['role'] as String?,
      enabled: json['enabled'] as bool?,
      licenseNumber: json['licenseNumber'] as String?,
      technicianRole: json['technicianRole'] as String?,
      username: json['username'] as String?,
      laboratoryId: parsedLaboratoryId,
    );
  }

  String get formattedDateOfBirth {
    if (dateOfBirth == null) return 'N/A';
    return DateFormat('d/M/yyyy').format(dateOfBirth!);
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}