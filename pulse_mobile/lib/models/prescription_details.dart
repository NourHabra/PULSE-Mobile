import 'package:intl/intl.dart';
import 'package:pulse_mobile/models/prescription_doctor.dart';
import 'package:pulse_mobile/models/prescriptionitem.dart';


class PrescriptionDetailsInfo {
  final int? prescriptionId;
  final String? notes; // Overall prescription notes (from nested 'prescription' object)
  final String? status;
  final GeneralDoctor2? doctor; // Doctor details (from nested 'prescription' object)
  final List<PrescriptionLineItem>? medications; // CHANGED: Now a list of PrescriptionLineItem objects
  final String? overallFormattedDate; // To hold the prescription's date

  PrescriptionDetailsInfo({
    this.prescriptionId,
    this.notes,
    this.status,
    this.doctor,
    this.medications, // Updated constructor
    this.overallFormattedDate,
  });

  // This factory method will now parse a single 'prescription' object
  // from the API response (from the first item in the list)
  factory PrescriptionDetailsInfo.fromPrescriptionJson(Map<String, dynamic> json) {
    // Access the nested 'prescription' object to get overall details
    final Map<String, dynamic>? nestedPrescription = json['prescription'];

    String date = 'N/A';
    if (nestedPrescription != null) {
      final Map<String, dynamic>? medicalRecordEntryData = nestedPrescription['medicalRecordEntry'];
      if (medicalRecordEntryData != null && medicalRecordEntryData['timestamp'] is List) {
        List<int> timestamp = List<int>.from(medicalRecordEntryData['timestamp']);
        if (timestamp.length >= 3) {
          try {
            DateTime dateTime = DateTime(
              timestamp[0], timestamp[1], timestamp[2],
              timestamp.length > 3 ? timestamp[3] : 0,
              timestamp.length > 4 ? timestamp[4] : 0,
              timestamp.length > 5 ? timestamp[5] : 0,
            );
            date = DateFormat('d/M/yyyy').format(dateTime);
          } catch (e) {
            print('Error parsing timestamp in PrescriptionDetailsInfo: $e');
          }
        }
      }
    }

    return PrescriptionDetailsInfo(
      prescriptionId: nestedPrescription?['prescriptionId'] as int?,
      notes: nestedPrescription?['notes'] as String?,
      status: nestedPrescription?['status'] as String?,
      doctor: nestedPrescription?['doctor'] != null
          ? GeneralDoctor2.fromJson(nestedPrescription!['doctor'] as Map<String, dynamic>)
          : null,
      medications: null, // This will be populated by the ApiService
      overallFormattedDate: date,
    );
  }

  // Add copyWith to PrescriptionDetailsInfo for immutability and setting medications
  PrescriptionDetailsInfo copyWith({
    int? prescriptionId,
    String? notes,
    String? status,
    GeneralDoctor2? doctor,
    List<PrescriptionLineItem>? medications, // Updated type for copyWith
    String? overallFormattedDate,
  }) {
    return PrescriptionDetailsInfo(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      doctor: doctor ?? this.doctor,
      medications: medications ?? this.medications,
      overallFormattedDate: overallFormattedDate ?? this.overallFormattedDate,
    );
  }
}
