// lib/models/profile_model.dart
class Profile {
  final String? pictureUrl;
  final double? height;
  final double? weight;
  final String? bloodType;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final List<int>? dateOfBirth;
  final String? placeOfBirth;
  final String? mobileNumber;
  final String? email;
  final String? address;

  Profile({
    this.pictureUrl,
    this.height,
    this.weight,
    this.bloodType,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.mobileNumber,
    this.email,
    this.address,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?; // Access the 'user' map
    return Profile(
      pictureUrl: user?['pictureUrl'] as String?,
      height: user?['height'] as double?,
      weight: user?['weight'] as double?,
      bloodType: user?['bloodType'] as String?,
      firstName: user?['firstName'] as String?,
      lastName: user?['lastName'] as String?,
      gender: user?['gender'] as String?,
      dateOfBirth: (user?['dateOfBirth'] as List?)?.cast<int>(),
      placeOfBirth: user?['placeOfBirth'] as String?,
      mobileNumber: user?['mobileNumber'] as String?,
      email: user?['email'] as String?,
      address: user?['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pictureUrl': pictureUrl,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'mobileNumber': mobileNumber,
      'email': email,
      'address': address,
    };
  }
}