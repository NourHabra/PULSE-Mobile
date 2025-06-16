// lib/models/LabResultsModel.dart

import 'package:intl/intl.dart';
import 'package:pulse_mobile/models/LabModel.dart'; // Ensure this path is correct for your LabModel

class LabResultListItem { // Renamed from LabResult to LabResultListItem
  final int testResultId; // The ID for the details screen
  final String testName;
  final String status;
  final LabModel? laboratory;
  final String formattedDate;

  LabResultListItem({
    required this.testResultId,
    required this.testName,
    required this.status,
    this.laboratory,
    required this.formattedDate,
  });

  factory LabResultListItem.fromJson(Map<String, dynamic> json) {
    String date = 'N/A';
    if (json['timestamp'] is List) {
      List<int> timestamp = List<int>.from(json['timestamp']);
      if (timestamp.length >= 3) {
        try {
          DateTime dateTime = DateTime(
            timestamp[0],
            timestamp[1],
            timestamp[2],
            timestamp.length > 3 ? timestamp[3] : 0,
            timestamp.length > 4 ? timestamp[4] : 0,
            timestamp.length > 5 ? timestamp[5] : 0,
          );
          date = DateFormat('d/M/yyyy').format(dateTime);
        } catch (e) {
          print('Error parsing LabResultListItem timestamp: $e');
        }
      }
    } else if (json['timestamp'] is String && json['timestamp'].isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(json['timestamp']);
        date = DateFormat('d/M/yyyy').format(dateTime);
      } catch (e) {
        print('Error parsing LabResultListItem string timestamp: $e');
      }
    }

    LabModel? extractedLaboratory;
    if (json['laboratory'] != null) {
      extractedLaboratory = LabModel.fromJson(json['laboratory'] as Map<String, dynamic>);
    }

    return LabResultListItem( // Use LabResultListItem here
      testResultId: json['testResultId'] as int? ?? -1,
      testName: json['test']?['name'] as String? ?? 'Unknown Test',
      status: json['status'] as String? ?? 'N/A',
      laboratory: extractedLaboratory,
      formattedDate: date,
    );
  }
}