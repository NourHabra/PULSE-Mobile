// lib/models/medication_model.dart
class Medication {
  final String tradeName;
  final String pharmaComposition;
  final String numOfTimes;
  final String untilDate;

  Medication({
    required this.tradeName,
    required this.pharmaComposition,
    required this.numOfTimes,
    required this.untilDate,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      tradeName: json['tradeName'] ?? '',
      pharmaComposition: json['pharmaComposition'] ?? '',
      numOfTimes: json['numOfTimes'] ?? '',
      untilDate: json['untilDate'] ?? '',
    );
  }
}