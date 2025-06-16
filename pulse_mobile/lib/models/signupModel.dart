// lib/models/signupModel.dart
import 'dart:io';

import 'package:image_picker/image_picker.dart';
class SignupUserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  double? height;
  double? weight;
  String? bloodType;
  String? gender;
  String? dateOfBirth;
  String? placeOfBirth;
  String? mobileNumber;
  String? address;
  String? pictureUrl; // This might be used for a URL if you were uploading and getting a URL back
  File? pictureFile; // For the profile picture file
  File? idImageFile;  // For the ID image file

  SignupUserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.height,
    this.weight,
    this.bloodType,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.mobileNumber,
    this.address,
    this.pictureUrl,
    this.pictureFile, // Initialize
    this.idImageFile, // Initialize
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "height": height,
      "weight": weight,
      "bloodType": bloodType,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "placeOfBirth": placeOfBirth,
      "mobileNumber": mobileNumber,
      "address": address,
      // 'pictureUrl': pictureUrl, // This will not be part of the 'data' JSON if sending files directly
    };
  }
}