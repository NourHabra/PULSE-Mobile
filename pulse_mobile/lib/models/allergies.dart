// lib/models/allergy_model.dart

class AllergyModel {
  final int id;
  final int patientId;
  final int allergyId;
  final String allergen;
  final String type;
  final String intensity;

  AllergyModel({
    required this.id,
    required this.patientId,
    required this.allergyId,
    required this.allergen,
    required this.type,
    required this.intensity,
  });

  // Factory constructor to create an AllergyModel from a JSON map
  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      id: json['id'] as int,
      patientId: json['patientId'] as int,
      allergyId: json['allergyId'] as int,
      allergen: json['allergen'] as String,
      type: json['type'] as String,
      intensity: json['intensity'] as String,
    );
  }
}