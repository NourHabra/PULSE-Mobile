// lib/models/medicalrecordlistitemsModel.dart
import 'package:intl/intl.dart';

class MedicalRecord {
  final int id;
  final String type;
  final String recordDate;
  final bool hasLabResult; // Indicates if this record should be treated as a lab result

  MedicalRecord({
    required this.id,
    required this.type,
    required this.recordDate,
    required this.hasLabResult,
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

    final int recordId = (json['medicalRecordEntry'] != null && json['medicalRecordEntry']['medicalRecordEntryId'] is int)
        ? json['medicalRecordEntry']['medicalRecordEntryId'] as int
        : (json['entryId'] is int ? json['entryId'] as int : -1);

    final String recordTitle = (json['medicalRecordEntry'] != null && json['medicalRecordEntry']['title'] is String)
        ? json['medicalRecordEntry']['title'] as String
        : (json['title'] is String ? json['title'] as String : 'Unknown Medical Record');

    // --- CRUCIAL CHANGE HERE: How hasLabResult is determined ---
    // Assuming titles like "Blood test result" or those containing "lab result"
    // are the actual indicators that it's a lab result entry.
    // You might need to adjust this condition based on all possible "lab result" titles from your API.
    final bool isLabResultBasedOnTitle = (recordTitle.toLowerCase().contains('lab result')) ||
        (recordTitle.toLowerCase().contains('blood test result'));

    // We can still keep the check for the 'labResult' field being non-null/non-empty,
    // just in case the API starts sending it properly in the future.
    // Use an OR condition to combine title-based detection with actual field presence.
    final bool isLabResultBasedOnFieldPresence = json['labResult'] != null &&
        !(json['labResult'] is Map && (json['labResult'] as Map).isEmpty) &&
        !(json['labResult'] is List && (json['labResult'] as List).isEmpty) &&
        !(json['labResult'] is String && (json['labResult'] as String).isEmpty);

    // Final decision for hasLabResult: true if title indicates it OR if the labResult field is actually populated.
    final bool finalHasLabResult = isLabResultBasedOnTitle || isLabResultBasedOnFieldPresence;


    // --- Debugging prints (keep these for now, they are very helpful) ---
    print('\n--- Parsing Record ID: ${recordId != -1 ? recordId : 'Unknown'} ---');
    print('  Original JSON entry: ${json}');
    print('  Value of json[\'labResult\']: ${json['labResult']}');
    print('  Type of json[\'labResult\']: ${json['labResult']?.runtimeType}');
    print('  Record Title: $recordTitle'); // Print the title for context
    print('  Calculated isLabResultBasedOnTitle: $isLabResultBasedOnTitle');
    print('  Calculated isLabResultBasedOnFieldPresence: $isLabResultBasedOnFieldPresence');
    print('  Final Calculated hasLabResult: $finalHasLabResult');
    print('-------------------------------------\n');
    // --- END Debugging prints ---

    return MedicalRecord(
      id: recordId,
      type: recordTitle,
      recordDate: formattedDate,
      hasLabResult: finalHasLabResult, // Use the new finalHasLabResult
    );
  }
}