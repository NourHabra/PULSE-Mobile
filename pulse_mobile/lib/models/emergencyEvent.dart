// lib/models/emergency_event_model.dart

class EmergencyEvent {
  final int id;
  final String? notes;
  final EmergencyWorker? emergencyWorker;
  final Patient? patient; // Patient is now directly in EmergencyEvent
  final MedicalRecordEntry? medicalRecordEntry;

  EmergencyEvent({
    required this.id,
    this.notes,
    this.emergencyWorker,
    this.patient,
    this.medicalRecordEntry,
  });

  factory EmergencyEvent.fromJson(Map<String, dynamic> json) {
    return EmergencyEvent(
      id: json['emergencyEventId'],
      notes: json['notes'],
      emergencyWorker: json['emergencyWorker'] != null
          ? EmergencyWorker.fromJson(json['emergencyWorker'])
          : null,
      patient: json['medicalRecordEntry'] != null && json['medicalRecordEntry']['patient'] != null
          ? Patient.fromJson(json['medicalRecordEntry']['patient'])
          : null,
      medicalRecordEntry: json['medicalRecordEntry'] != null
          ? MedicalRecordEntry.fromJson(json['medicalRecordEntry'])
          : null,
    );
  }
}

class EmergencyWorker {
  final int userId;
  final String firstName;
  final String lastName;
  final String authority;

  EmergencyWorker({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.authority,
  });

  factory EmergencyWorker.fromJson(Map<String, dynamic> json) {
    return EmergencyWorker(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      authority: (json['authorities'] as List<dynamic>?)
          ?.firstWhere((auth) => auth['authority'] != null)['authority'] ??
          'N/A', // Adjust based on how authority is exactly structured
    );
  }
}

class Patient {
  final int userId;
  final String firstName;
  final String lastName;

  Patient({
    required this.userId,
    required this.firstName,
    required this.lastName,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}

class MedicalRecordEntry {
  final int medicalRecordEntryId;
  final String title;
  final DateTime timestamp;

  MedicalRecordEntry({
    required this.medicalRecordEntryId,
    required this.title,
    required this.timestamp,
  });

  factory MedicalRecordEntry.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ts = json['timestamp'];
    return MedicalRecordEntry(
      medicalRecordEntryId: json['medicalRecordEntryId'],
      title: json['title'],
      timestamp: DateTime(ts[0], ts[1], ts[2], ts[3], ts[4]),
    );
  }
}