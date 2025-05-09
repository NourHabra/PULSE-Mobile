class SignupUserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  double? height;
  double? weight;
  String? bloodType;
  String? fingerprint;
  String? gender;
  String? dateOfBirth;
  String? placeOfBirth;
  String? mobileNumber;
  String? address;
  String? pictureUrl;

  SignupUserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.height,
    this.weight,
    this.bloodType,
    this.fingerprint,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.mobileNumber,
    this.address,
    this.pictureUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'fingerprint': fingerprint,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'mobileNumber': mobileNumber,
      'address': address,
      'pictureUrl': pictureUrl,
    };
  }
}