// lib/models/chronic_disease_model.dart

import 'dart:convert';

class ChronicDiseaseModel {
  final int id;
  final int patientId;
  final int chronicDiseaseId;
  final String disease;
  final String type;
  final String intensity;
  final List<int> startDate; // Stored as a list [year, month, day]

  ChronicDiseaseModel({
    required this.id,
    required this.patientId,
    required this.chronicDiseaseId,
    required this.disease,
    required this.type,
    required this.intensity,
    required this.startDate,
  });

  // Factory constructor to create a ChronicDiseaseModel from a JSON map.
  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) {
    return ChronicDiseaseModel(
      id: json['id'] as int,
      patientId: json['patientId'] as int,
      chronicDiseaseId: json['chronicDiseaseId'] as int,
      disease: json['disease'] as String,
      type: json['type'] as String,
      intensity: json['intensity'] as String,
      startDate: List<int>.from(json['startDate'] as List), // Cast to List<int>
    );
  }

  // Method to convert a ChronicDiseaseModel instance to a JSON map (optional, but good practice)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'chronicDiseaseId': chronicDiseaseId,
      'disease': disease,
      'type': type,
      'intensity': intensity,
      'startDate': startDate,
    };
  }

  // Helper method to format the startDate into a readable string (e.g., YYYY-MM-DD)
  String get formattedStartDate {
    if (startDate.length == 3) {
      final year = startDate[0];
      final month = startDate[1].toString().padLeft(2, '0');
      final day = startDate[2].toString().padLeft(2, '0');
      return '$year-$month-$day';
    }
    return 'N/A';
  }
}

// Helper function to parse a list of JSON objects into a list of ChronicDiseaseModel.
List<ChronicDiseaseModel> parseChronicDiseases(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ChronicDiseaseModel>((json) => ChronicDiseaseModel.fromJson(json))
      .toList();
}
