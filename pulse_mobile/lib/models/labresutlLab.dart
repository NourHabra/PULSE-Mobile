import 'package:pulse_mobile/models/technician_model.dart';
import 'dart:developer'; // Import for log

class LabResultLabModel {
  final int? laboratoryId;
  final String? name;
  final String? licenseNumber;
  final String? workingHours;
  final TechnicianModel? manager;
  final String? phone;
  final String? address;
  final String? locationCoordinates;

  LabResultLabModel({
    this.laboratoryId,
    this.name,
    this.licenseNumber,
    this.workingHours,
    this.manager,
    this.phone,
    this.address,
    this.locationCoordinates,
  });

  factory LabResultLabModel.fromJson(Map<String, dynamic> json) {
    log('LabResultLabModel.fromJson received JSON: $json');

    // Check parsing of laboratoryId
    log('Attempting to parse laboratoryId. Value in JSON: ${json['laboratoryId']}');
    final int? parsedLaboratoryId = json['laboratoryId'] as int?;
    log('Parsed laboratoryId: $parsedLaboratoryId');

    TechnicianModel? parsedManager;
    if (json['manager'] != null) {
      log('Calling TechnicianModel.fromJson for manager...');
      parsedManager = TechnicianModel.fromJson(json['manager'] as Map<String, dynamic>);
      log('TechnicianModel.fromJson returned: $parsedManager');
    } else {
      log('Manager is null in LabResultLabModel JSON.');
    }

    return LabResultLabModel(
      laboratoryId: parsedLaboratoryId,
      name: json['name'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      workingHours: json['workingHours'] as String?,
      manager: parsedManager,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      locationCoordinates: json['locationCoordinates'] as String?,
    );
  }
}