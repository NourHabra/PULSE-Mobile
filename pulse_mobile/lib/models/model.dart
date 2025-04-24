class UserModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? placeOfBirth;
  final String? pictureUrl;
  final String? role;
  final String? authToken;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.placeOfBirth,
    this.pictureUrl,
    this.role,
    this.authToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['mobileNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      placeOfBirth: json['placeOfBirth'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
      role: json['role'] as String?,
      authToken: json['authToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'placeOfBirth': placeOfBirth,
      'pictureUrl': pictureUrl,
      'role': role,
      'authToken': authToken,
    };
  }
}
