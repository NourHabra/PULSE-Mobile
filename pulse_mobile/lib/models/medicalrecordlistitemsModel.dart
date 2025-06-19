import 'package:intl/intl.dart';

class MedicalRecord {
  final int id;
  final String type;
  final String recordDate;
  final bool hasLabResult;

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


    final bool isLabResultBasedOnTitle = (recordTitle.toLowerCase().contains('lab result')) ||
        (recordTitle.toLowerCase().contains('blood test result'));


    final bool isLabResultBasedOnFieldPresence = json['labResult'] != null &&
        !(json['labResult'] is Map && (json['labResult'] as Map).isEmpty) &&
        !(json['labResult'] is List && (json['labResult'] as List).isEmpty) &&
        !(json['labResult'] is String && (json['labResult'] as String).isEmpty);

    final bool finalHasLabResult = isLabResultBasedOnTitle || isLabResultBasedOnFieldPresence;


    print('\n--- Parsing Record ID: ${recordId != -1 ? recordId : 'Unknown'} ---');
    print('  Original JSON entry: ${json}');
    print('  Value of json[\'labResult\']: ${json['labResult']}');
    print('  Type of json[\'labResult\']: ${json['labResult']?.runtimeType}');
    print('  Record Title: $recordTitle'); // Print the title for context
    print('  Calculated isLabResultBasedOnTitle: $isLabResultBasedOnTitle');
    print('  Calculated isLabResultBasedOnFieldPresence: $isLabResultBasedOnFieldPresence');
    print('  Final Calculated hasLabResult: $finalHasLabResult');
    print('-------------------------------------\n');

    return MedicalRecord(
      id: recordId,
      type: recordTitle,
      recordDate: formattedDate,
      hasLabResult: finalHasLabResult,
    );
  }
}