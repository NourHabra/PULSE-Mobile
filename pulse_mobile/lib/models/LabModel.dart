class LabModel {
  final int id;
  final String name;
  final String address;
  final String? locationCoordinates;
  final String? licenseNumber; // Added
  final String? workingHours; // Added
  final String? phone; // Added

  LabModel({
    required this.id,
    required this.name,
    required this.address,
    this.locationCoordinates,
    this.licenseNumber, // Added
    this.workingHours, // Added
    this.phone, // Added
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      id: json['laboratoryId'] as int? ?? 0,
      name: json['name'] as String? ?? 'N/A',
      address: json['address'] as String? ?? 'N/A',
      locationCoordinates: json['locationCoordinates'] as String?,
      licenseNumber: json['licenseNumber'] as String?, // Parse licenseNumber
      workingHours: json['workingHours'] as String?, // Parse workingHours
      phone: json['phone'] as String?, // Parse phone
    );
  }
}
