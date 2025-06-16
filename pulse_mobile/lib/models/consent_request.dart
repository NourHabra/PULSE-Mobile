// lib/models/consent_request.dart

class ConsentRequest {
  final int id;
  final int doctorId;
  final String message;
  String status; // This will change from PENDING to APPROVED/DENIED
  final DateTime receivedAt;// *** CHANGED to be nullable ***

  ConsentRequest({
    required this.id,
    required this.doctorId,
    required this.message,
    required this.status,
    required this.receivedAt, // Now optional in constructor
  });

  // Factory constructor to create ConsentRequest from JSON
  factory ConsentRequest.fromJson(Map<String, dynamic> json) {
    DateTime? parsedRequestedAt;


    return ConsentRequest(
      id: json['consentId'], // Ensure this matches your JSON key
      doctorId: json['doctorId'],
      message: 'Doctor with ID ${json['doctorId']} requested your consent to access your medical record.',
      status: json['status'],
      receivedAt: DateTime.now(),
    );
  }
}