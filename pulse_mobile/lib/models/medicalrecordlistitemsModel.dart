import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalRecord {
  final int id; // Corresponds to medicalRecordEntryId
  final String type; // Corresponds to title
  final String recordDate; // Parsed from timestamp

  MedicalRecord({
    required this.id,
    required this.type,
    required this.recordDate,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    String formattedDate = 'N/A';
    if (json['timestamp'] is List) {
      List<int> timestamp = List<int>.from(json['timestamp']);
      if (timestamp.length >= 3) {
        try {
          DateTime date = DateTime(
            timestamp[0],
            timestamp[1],
            timestamp[2],
            timestamp.length > 3 ? timestamp[3] : 0,
            timestamp.length > 4 ? timestamp[4] : 0,
            timestamp.length > 5 ? timestamp[5] : 0,
          );
          formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);
        } catch (e) {
          print('Error parsing timestamp: $e');
        }
      }
    }

    // Access the 'medicalRecordEntry' object first
    final Map<String, dynamic>? medicalRecordEntryData = json['medicalRecordEntry'];

    // Safely get the 'medicalRecordEntryId' from the nested object
    // Provide a default value (e.g., 0 or throw an error) if it's null
    final int recordId = medicalRecordEntryData?['medicalRecordEntryId'] as int? ?? json['entryId'] as int;

    // Safely get the 'title' from the top level or nested object
    final String recordTitle = json['title'] as String? ?? medicalRecordEntryData?['title'] as String? ?? 'Unknown Medical Record';


    return MedicalRecord(
      id: recordId,
      type: recordTitle,
      recordDate: formattedDate,
    );
  }
}