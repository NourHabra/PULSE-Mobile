
class SavedDoctorModel {
  final int savedDoctorEntryId;
  final int doctorUserId;
  final String? doctorFirstName;
  final String? doctorLastName;
  final String? pictureUrl;
  final String? specialization;

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


  int get id => doctorUserId;


  String get fullName => '${doctorFirstName ?? ''} ${doctorLastName ?? ''}';
}