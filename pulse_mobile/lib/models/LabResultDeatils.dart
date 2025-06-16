import 'package:pulse_mobile/models/labresutlLab.dart';
import 'package:pulse_mobile/models/technician_model.dart';
import 'package:pulse_mobile/models/testDetails.dart';
import 'package:pulse_mobile/models/medical_record_details_model.dart';
import 'dart:developer'; // Import for log

class LabResultDetails {
  final int testResultId;
  final LabResultLabModel? laboratory;
  final TestDetails? test;
  final TechnicianModel? technician;
  final String? status;
  final String? resultsAttachment;
  final String? technicianNotes;
  final MedicalRecordDetails? medicalRecordEntry;

  LabResultDetails({
    required this.testResultId,
    this.laboratory,
    this.test,
    this.technician,
    this.status,
    this.resultsAttachment,
    this.technicianNotes,
    this.medicalRecordEntry,
  });

  factory LabResultDetails.fromJson(Map<String, dynamic> json) {
    log('LabResultDetails.fromJson received JSON: $json'); // Print entire JSON

    // Parsing testResultId (already robust, but good to check)
    log('Attempting to parse testResultId. Value in JSON: ${json['testResultId']}');
    final int parsedTestResultId = json['testResultId'] as int? ?? -1;
    log('Parsed testResultId: $parsedTestResultId');


    LabResultLabModel? parsedLaboratory;
    if (json['laboratory'] != null) {
      log('Calling LabResultLabModel.fromJson for laboratory...');
      parsedLaboratory = LabResultLabModel.fromJson(json['laboratory'] as Map<String, dynamic>);
      log('LabResultLabModel.fromJson returned: $parsedLaboratory');
    } else {
      log('Laboratory is null in LabResultDetails JSON.');
    }

    TestDetails? parsedTest;
    if (json['test'] != null) {
      log('Calling TestDetails.fromJson for test...');
      parsedTest = TestDetails.fromJson(json['test'] as Map<String, dynamic>);
      log('TestDetails.fromJson returned: $parsedTest');
    } else {
      log('Test is null in LabResultDetails JSON.');
    }

    TechnicianModel? parsedTechnician;
    if (json['technician'] != null) {
      log('Calling TechnicianModel.fromJson for technician...');
      parsedTechnician = TechnicianModel.fromJson(json['technician'] as Map<String, dynamic>);
      log('TechnicianModel.fromJson returned: $parsedTechnician');
    } else {
      log('Technician is null in LabResultDetails JSON.');
    }

    MedicalRecordDetails? parsedMedicalRecordEntry;
    if (json['medicalRecordEntry'] != null) {
      log('Calling MedicalRecordDetails.fromJson for medicalRecordEntry...');
      parsedMedicalRecordEntry = MedicalRecordDetails.fromJson(json['medicalRecordEntry'] as Map<String, dynamic>);
      log('MedicalRecordDetails.fromJson returned: $parsedMedicalRecordEntry');
    } else {
      log('MedicalRecordEntry is null in LabResultDetails JSON.');
    }

    return LabResultDetails(
      testResultId: parsedTestResultId,
      laboratory: parsedLaboratory,
      test: parsedTest,
      technician: parsedTechnician,
      status: json['status'] as String?,
      resultsAttachment: json['resultsAttachment'] as String?,
      technicianNotes: json['technicianNotes'] as String?,
      medicalRecordEntry: parsedMedicalRecordEntry,
    );
  }
}