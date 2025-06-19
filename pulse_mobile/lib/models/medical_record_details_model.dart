import 'package:intl/intl.dart';
import 'dart:developer';

class MedicalRecordDetails {
  final int? entryId;
  final String title;
  final String formattedDate;
  final String doctorName;
  final String doctorSpecialty;
  final String? officialDiagnosis;
  final String? diagnosisFollowUps;
  final String? emergencyNotes;
  final String? prescriptionNotes;
  final String? prescriptionStatus;



  MedicalRecordDetails({
    this.entryId,
    required this.title,
    required this.formattedDate,
    required this.doctorName,
    required this.doctorSpecialty,
    this.officialDiagnosis,
    this.diagnosisFollowUps,
    this.emergencyNotes,
    this.prescriptionNotes,
    this.prescriptionStatus,
  });

  factory MedicalRecordDetails.fromJson(Map<String, dynamic> json) {
    log('MedicalRecordDetails.fromJson received JSON: $json');

    log('Attempting to parse entryId. Value in JSON: ${json['entryId']}');
    final int? parsedEntryId = json['entryId'] as int?;
    log('Parsed entryId: $parsedEntryId');


    String date = 'N/A';
    dynamic rawTimestamp = json['timestamp'];
    if (json['medicalRecordEntry'] != null && json['medicalRecordEntry']['timestamp'] != null) {
      rawTimestamp = json['medicalRecordEntry']['timestamp'];
    }


    if (rawTimestamp is List) {
      List<int> timestamp = List<int>.from(rawTimestamp);
      if (timestamp.length >= 3) {
        try {
          DateTime dateTime = DateTime(
            timestamp[0], timestamp[1], timestamp[2],
            timestamp.length > 3 ? timestamp[3] : 0,
            timestamp.length > 4 ? timestamp[4] : 0,
            timestamp.length > 5 ? timestamp[5] : 0,
          );
          date = DateFormat('d/M/yyyy').format(dateTime);
        } catch (e) {
          log('Error parsing list timestamp in MedicalRecordDetails: $e');
        }
      }
    } else if (rawTimestamp is String && rawTimestamp.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(rawTimestamp);
        date = DateFormat('d/M/yyyy').format(dateTime);
      } catch (e) {
        log('Error parsing string timestamp in MedicalRecordDetails: $e');
      }
    }

    String doctorName = 'N/A';
    String doctorSpecialty = 'N/A';

    if (json['diagnosis'] != null && json['diagnosis']['doctor'] != null) {
      doctorName = '${json['diagnosis']['doctor']['firstName'] ?? ''} ${json['diagnosis']['doctor']['lastName'] ?? ''}'.trim();
      doctorSpecialty = json['diagnosis']['doctor']['specialization'] as String? ?? 'N/A';
    } else if (json['prescription'] != null && json['prescription']['doctor'] != null) {
      doctorName = '${json['prescription']['doctor']['firstName'] ?? ''} ${json['prescription']['doctor']['lastName'] ?? ''}'.trim();
      doctorSpecialty = json['prescription']['doctor']['specialization'] as String? ?? 'N/A';
    } else if (json['emergencyEvent'] != null && json['emergencyEvent']['emergencyWorker'] != null) {
      doctorName = '${json['emergencyEvent']['emergencyWorker']['firstName'] ?? ''} ${json['emergencyEvent']['emergencyWorker']['lastName'] ?? ''}'.trim();
      doctorSpecialty = 'Emergency Worker';
    }


    final String? officialDiagnosis = json['diagnosis']?['description'] as String?;
    final String? diagnosisFollowUps = json['diagnosis']?['followUps'] as String?;

    final String? emergencyNotes = json['emergencyEvent']?['notes'] as String?;
    final String? prescriptionNotes = json['prescription']?['notes'] as String?;
    final String? prescriptionStatus = json['prescription']?['status'] as String?;

    return MedicalRecordDetails(
      entryId: parsedEntryId,
      title: json['title'] as String? ?? 'N/A',
      formattedDate: date,
      doctorName: doctorName,
      doctorSpecialty: doctorSpecialty,
      officialDiagnosis: officialDiagnosis,
      diagnosisFollowUps: diagnosisFollowUps,
      emergencyNotes: emergencyNotes,
      prescriptionNotes: prescriptionNotes,
      prescriptionStatus: prescriptionStatus,
    );
  }
}