import 'dart:io';

class SignupUserModel {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? dateOfBirth;
  String? placeOfBirth;
  double? height;
  double? weight;
  File? bloodTestImage;
  File? idImage;

  SignupUserModel({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
    this.placeOfBirth,
    this.height,
    this.weight,
    this.bloodTestImage,
    this.idImage,
  });

  // toJson method to convert the object to a JSON map for sending to the API.  Exclude images.  Corrected to return Map<String, String>
  Map<String, String> toJson() {
    return {
      'email': email ?? '', // Handle nulls with a default value
      'password': password ?? '',
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      'mobileNumber': phoneNumber ?? '',
      'dateOfBirth': dateOfBirth ?? '',
      'placeOfBirth': placeOfBirth ?? '',
      'height': height?.toString() ?? '', // Convert double to String
      'weight': weight?.toString() ?? '', // Convert double to String
    };
  }
}
