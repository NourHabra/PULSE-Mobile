
class Prescription {
  final int id;
  final String doctorName;
  final String doctorSpeciality;
  final String validUntil;

  Prescription({
    required this.id,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.validUntil,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      doctorSpeciality: json['doctorSpeciality'] ?? '',
      validUntil: json['validUntil'] ?? '',
    );
  }
}