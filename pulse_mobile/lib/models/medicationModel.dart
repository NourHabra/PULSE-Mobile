import 'package:intl/intl.dart'; // Import for date formatting

class Medication {
  final int id; // Corresponds to drug.drugId
  final String name; // Corresponds to drug.name
  final String activeSubstance; // Corresponds to drug.activeSubstance
  final String dosage; // Corresponds to top-level 'dosage'
  final String duration; // Corresponds to top-level 'duration'
  final String prescribedDate; // Parsed from prescription.medicalRecordEntry.timestamp

  Medication({
    required this.id,
    required this.name,
    required this.activeSubstance,
    required this.dosage,
    required this.duration,
    required this.prescribedDate,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    // Safely access nested 'drug' object
    final Map<String, dynamic>? drugData = json['drug'];
    final int drugId = drugData?['drugId'] as int? ?? 0; // Provide a default if null
    final String drugName = drugData?['name'] as String? ?? 'N/A';
    final String activeSubstance = drugData?['activeSubstance'] as String? ?? 'N/A';

    // Safely access top-level 'dosage' and 'duration'
    final String dosage = json['dosage'] as String? ?? 'N/A';
    final String duration = json['duration'] as String? ?? 'N/A';

    // Safely access nested 'prescription' -> 'medicalRecordEntry' -> 'timestamp'
    String formattedDate = 'N/A';
    final Map<String, dynamic>? prescriptionData = json['prescription'];
    final Map<String, dynamic>? medicalRecordEntryData = prescriptionData?['medicalRecordEntry'];

    if (medicalRecordEntryData != null && medicalRecordEntryData['timestamp'] is List) {
      List<int> timestamp = List<int>.from(medicalRecordEntryData['timestamp']);
      if (timestamp.length >= 3) {
        try {
          DateTime date = DateTime(
            timestamp[0], // Year
            timestamp[1], // Month
            timestamp[2], // Day
            timestamp.length > 3 ? timestamp[3] : 0, // Hour
            timestamp.length > 4 ? timestamp[4] : 0, // Minute
            timestamp.length > 5 ? timestamp[5] : 0, // Second
          );
          // Format as 'dd/MM/yyyy' or 'dd/MM/yyyy HH:mm' as needed
          // The request implies just the date for 'untilDate'
          formattedDate = DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          print('Error parsing timestamp for medication: $e');
        }
      }
    }

    return Medication(
      id: drugId,
      name: drugName,
      activeSubstance: activeSubstance,
      dosage: dosage,
      duration: duration,
      prescribedDate: formattedDate,
    );
  }
}