class Prescription {
  final int id;
  final String doctorName;
  final String doctorSpeciality;
  final String notes; // Changed from validUntil

  Prescription({
    required this.id,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.notes, // Changed from validUntil
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['prescriptionId'] ?? 0, // Adjusted to match your JSON (prescriptionId)
      doctorName: json['doctor']['firstName'] != null && json['doctor']['lastName'] != null
          ? '${json['doctor']['firstName']} ${json['doctor']['lastName']}'
          : '',
      doctorSpeciality: json['doctor']['specialization'] ?? '',
      notes: json['notes'] ?? '', // Changed from validUntil
    );
  }
}