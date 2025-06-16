// lib/models/drugModel.dart
class Drug {
  final int? drugId;
  final String? name;
  final String? strength;
  final String? manufacturer;
  final String? activeSubstance;
  final int? amount;
  final String? type;

  Drug({
    this.drugId,
    this.name,
    this.strength,
    this.manufacturer,
    this.activeSubstance,
    this.amount,
    this.type,
  });

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      drugId: json['drugId'] as int?,
      name: json['name'] as String?,
      strength: json['strength'] as String?,
      manufacturer: json['manufacturer'] as String?,
      activeSubstance: json['activeSubstance'] as String?,
      amount: json['amount'] as int?,
      type: json['type'] as String?,
    );
  }
}
