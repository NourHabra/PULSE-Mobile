// lib/models/prescriptionLineItemModel.dart
import 'package:intl/intl.dart';
import 'drug_model.dart'; // Import the new Drug model

class PrescriptionLineItem {
  final int? id; // The ID of this specific prescription-drug entry
  final Drug? drug; // The drug details
  final String? dosage;
  final String? duration;
  final String? notes; // Notes specific to this line item
  final String? prescribedDate; // Date this specific drug was prescribed

  PrescriptionLineItem({
    this.id,
    this.drug,
    this.dosage,
    this.duration,
    this.notes,
    this.prescribedDate,
  });

  factory PrescriptionLineItem.fromJson(Map<String, dynamic> json) {
    // Parse nested 'drug' object
    final Map<String, dynamic>? drugData = json['drug'];
    final Drug? parsedDrug = drugData != null ? Drug.fromJson(drugData) : null;

    // Parse specific details for this line item
    final String dosage = json['dosage'] as String? ?? 'N/A';
    final String duration = json['duration'] as String? ?? 'N/A';
    final String notes = json['notes'] as String? ?? 'No specific notes for this drug.';

    // Parse the prescribed date from the nested 'prescription' -> 'medicalRecordEntry' -> 'timestamp'
    String formattedDate = 'N/A';
    final Map<String, dynamic>? prescriptionData = json['prescription'];
    final Map<String, dynamic>? medicalRecordEntryData = prescriptionData?['medicalRecordEntry'];

    if (medicalRecordEntryData != null && medicalRecordEntryData['timestamp'] is List) {
      List<int> timestamp = List<int>.from(medicalRecordEntryData['timestamp']);
      if (timestamp.length >= 3) {
        try {
          DateTime date = DateTime(
            timestamp[0], timestamp[1], timestamp[2],
            timestamp.length > 3 ? timestamp[3] : 0,
            timestamp.length > 4 ? timestamp[4] : 0,
            timestamp.length > 5 ? timestamp[5] : 0,
          );
          formattedDate = DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          print('Error parsing timestamp for PrescriptionLineItem: $e');
        }
      }
    }

    return PrescriptionLineItem(
      id: json['id'] as int?,
      drug: parsedDrug,
      dosage: dosage,
      duration: duration,
      notes: notes,
      prescribedDate: formattedDate,
    );
  }
}
