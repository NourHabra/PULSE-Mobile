// lib/models/profile_model.dart
class Profile {
  final String? pictureUrl;
  final double? height;
  final double? weight;
  final String? bloodType;

  Profile({
    this.pictureUrl,
    this.height,
    this.weight,
    this.bloodType,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      pictureUrl: json['pictureUrl'] as String?,
      height: json['height'] as double?,
      weight: json['weight'] as double?,
      bloodType: json['bloodType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pictureUrl': pictureUrl,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
    };
  }
}
