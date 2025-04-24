import 'model.dart';

class PatientModel extends UserModel {
  final double? height;
  final double? weight;
  final String? bloodType;
//final String? fingerprint;// omitted for now.

  PatientModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.dateOfBirth,
    required super.placeOfBirth,
    required super.pictureUrl,
    required super.role,
    required super.authToken,
    this.height,
    this.weight,
    this.bloodType,
//this.fingerprint,
  }) : super();

  factory PatientModel.fromJson(Map<String, dynamic> json) {
// You MUST call the superclass's fromJson to get the User part
    final user = UserModel.fromJson(json);
    return PatientModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      dateOfBirth: user.dateOfBirth,
      placeOfBirth: user.placeOfBirth,
      pictureUrl: user.pictureUrl,
      role: user.role,
      authToken: user.authToken,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bloodType: json['bloodType'] as String?,
//fingerprint: json['fingerprint'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
// call super.toJson() to get the User part, and add patient-specific fields
    final userJson = super.toJson();
    return {
      ...userJson,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
//'fingerprint': fingerprint,
    };
  }
}
