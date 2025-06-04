// lib/models/mySavedDoctor_model.dart

class SavedDoctorModel {
  final int savedDoctorEntryId; // The ID of the saved entry itself ("savedDoctorId" in JSON)
  final int doctorUserId;       // The ID of the doctor (from "doctor.userId" in JSON)
  final String? doctorFirstName;
  final String? doctorLastName;
  final String? pictureUrl;      // From "doctor.pictureUrl" in JSON
  final String? specialization;  // From "doctor.specialization" in JSON

  SavedDoctorModel({
    required this.savedDoctorEntryId,
    required this.doctorUserId,
    this.doctorFirstName,
    this.doctorLastName,
    this.pictureUrl,
    this.specialization,
  });

  factory SavedDoctorModel.fromJson(Map<String, dynamic> json) {
    // Extract the top-level 'savedDoctorId'
    final int savedEntryId = json['savedDoctorId'] as int;

    // Extract the nested 'doctor' object
    final Map<String, dynamic> doctorJson = json['doctor'] as Map<String, dynamic>;

    return SavedDoctorModel(
      savedDoctorEntryId: savedEntryId,
      doctorUserId: doctorJson['userId'] as int,
      doctorFirstName: doctorJson['firstName'] as String?,
      doctorLastName: doctorJson['lastName'] as String?,
      pictureUrl: doctorJson['pictureUrl'] as String?,
      specialization: doctorJson['specialization'] as String?,
    );
  }

  // --- Crucial for MySavedDetailsController filtering ---
  // This getter ensures 'item.id' in the controller's filter
  // refers to the doctor's userId, which is likely what your
  // 'savedItemIds' list contains.
  int get id => doctorUserId;

  // --- Used by MySavedCard ---
  // This getter combines first and last name for display.
  String get fullName => '${doctorFirstName ?? ''} ${doctorLastName ?? ''}';
}