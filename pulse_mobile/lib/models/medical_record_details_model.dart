import 'package:intl/intl.dart';

class MedicalRecordDetails {
  final int entryId;
  final String title;
  final String formattedDate;
  final String doctorName;
  final String doctorSpecialty;
  final String? symptoms; // Assuming symptoms might be a string
  final String? diagnosis;
  final String? medicalPrescription;
  final String? labTest;
  final String? notes;

  MedicalRecordDetails({
    required this.entryId,
    required this.title,
    required this.formattedDate,
    required this.doctorName,
    required this.doctorSpecialty,
    this.symptoms,
    this.diagnosis,
    this.medicalPrescription,
    this.labTest,
    this.notes,
  });

  factory MedicalRecordDetails.fromJson(Map<String, dynamic> json) {
    // Parse timestamp
    String date = 'N/A';
    if (json['timestamp'] is List) {
      List<int> timestamp = List<int>.from(json['timestamp']);
      if (timestamp.length >= 3) {
        try {
          DateTime dateTime = DateTime(
            timestamp[0],
            timestamp[1],
            timestamp[2],
            timestamp.length > 3 ? timestamp[3] : 0,
            timestamp.length > 4 ? timestamp[4] : 0,
            timestamp.length > 5 ? timestamp[5] : 0,
          );
          date = DateFormat('d/M/yyyy').format(dateTime); // Format as 1/8/2022
        } catch (e) {
          print('Error parsing timestamp in MedicalRecordDetails: $e');
        }
      }
    }

    // Extracting doctor's name and specialty (assuming from emergencyEvent.emergencyWorker)
    String doctorName = 'N/A';
    String doctorSpecialty = 'N/A'; // Assuming specialty is not directly in the API for doctor
    // Let's assume 'Endocrinologist' is hardcoded or inferred from context
    // or comes from a 'role' if API provides it
    if (json['emergencyEvent'] != null && json['emergencyEvent']['emergencyWorker'] != null) {
      final worker = json['emergencyEvent']['emergencyWorker'];
      doctorName = '${worker['firstName']} ${worker['lastName']}';
      // If your API provides specialty for the doctor, parse it here
      // For now, we'll use a placeholder as in the screenshot: "Endocrinologist"
      doctorSpecialty = 'Endocrinologist'; // Placeholder based on screenshot
    } else if (json['doctor'] != null) { // If there's a direct 'doctor' field
      doctorName = '${json['doctor']['firstName']} ${json['doctor']['lastName']}';
      doctorSpecialty = json['doctor']['specialty'] ?? 'N/A';
    }


    // Access the 'medicalRecordEntry' object first if it exists
    final Map<String, dynamic>? medicalRecordEntryData = json['medicalRecordEntry'];

    // Prioritize data from medicalRecordEntry if available, otherwise from top-level
    final int id = medicalRecordEntryData?['medicalRecordEntryId'] as int? ?? json['entryId'] as int;
    final String titleValue = medicalRecordEntryData?['title'] as String? ?? json['title'] as String? ?? 'No Title';
    final String? symptomsValue = medicalRecordEntryData?['symptoms'] as String? ?? json['symptoms'] as String?;
    final String? diagnosisValue = medicalRecordEntryData?['diagnosis'] as String? ?? json['diagnosis'] as String?;
    final String? prescriptionValue = medicalRecordEntryData?['medicalPrescription'] as String? ?? json['medicalPrescription'] as String?;
    final String? labTestValue = medicalRecordEntryData?['labTest'] as String? ?? json['labTest'] as String?;
    final String? notesValue = medicalRecordEntryData?['notes'] as String? ?? json['notes'] as String?;


    return MedicalRecordDetails(
      entryId: id,
      title: titleValue,
      formattedDate: date,
      doctorName: doctorName,
      doctorSpecialty: doctorSpecialty,
      symptoms: symptomsValue,
      diagnosis: diagnosisValue,
      medicalPrescription: prescriptionValue,
      labTest: labTestValue,
      notes: notesValue,
    );
  }
}