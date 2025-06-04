class GeneralDoctor {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? specialization;
  final String? licenseNumber;
  final String? workingHours;
  final String? biography;
  final String? gender;
  final List<int>? dateOfBirth;
  final String? placeOfBirth;
  final String? mobileNumber;
  final String? address;
  final String? pictureUrl;
  final String? coordinates;

  GeneralDoctor({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.specialization,
    this.licenseNumber,
    this.workingHours,
    this.biography,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.mobileNumber,
    this.address,
    this.pictureUrl,
    this.coordinates,
  });

  factory GeneralDoctor.fromJson(Map<String, dynamic> json) {
    return GeneralDoctor(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      workingHours: json['workingHours'],
      biography: json['biography'],
      gender: json['gender'],
      dateOfBirth: (json['dateOfBirth'] as List?)?.cast<int>(),
      placeOfBirth: json['placeOfBirth'],
      mobileNumber: json['mobileNumber'],
      address: json['address'],
      pictureUrl: json['pictureUrl'],
      coordinates: json['coordinates'],
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}