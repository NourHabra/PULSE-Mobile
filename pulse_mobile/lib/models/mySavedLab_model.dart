// lib/models/mySavedLab_model.dart

class SavedLaboratoryModel {
  final int savedLaboratoryEntryId;
  final int laboratoryId; // The ID of the laboratory (crucial for comparison)
  final String? name;
  final String? address;
  final String? pictureUrl; // NEW: Added pictureUrl field

  SavedLaboratoryModel({
    required this.savedLaboratoryEntryId,
    required this.laboratoryId,
    this.name,
    this.address,
    this.pictureUrl, // NEW: Include in constructor
  });

  factory SavedLaboratoryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> labJson = json['laboratory'] as Map<String, dynamic>;

    return SavedLaboratoryModel(
      savedLaboratoryEntryId: json['savedLaboratoryId'] as int,
      laboratoryId: labJson['laboratoryId'] as int,
      name: labJson['name'] as String?,
      address: labJson['address'] as String?,
      // NEW: Assign your asset path here
      pictureUrl: 'assets/lab.jpg',
    );
  }

  // This getter allows 'item.id' to work for SavedLaboratoryModel
  int get id => laboratoryId;
}