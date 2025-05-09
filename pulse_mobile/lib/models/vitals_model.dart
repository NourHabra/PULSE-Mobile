class Vital {
  final int id;
  final int patientId;
  final int vitalId;
  final String name;
  final String description;
  final String normalValue;
  final String measurement;
  final DateTime timestamp;

  Vital({
    required this.id,
    required this.patientId,
    required this.vitalId,
    required this.name,
    required this.description,
    required this.normalValue,
    required this.measurement,
    required this.timestamp,
  });

  factory Vital.fromJson(Map<String, dynamic> json) {
    // Handle the timestamp array conversion to DateTime
    List<int> timestampList = (json['timestamp'] as List<dynamic>).cast<int>();
    DateTime dateTime = DateTime(
      timestampList[0],
      timestampList[1],
      timestampList[2],
      timestampList[3],
      timestampList[4],
    );

    return Vital(
      id: json['id'] as int,
      patientId: json['patientId'] as int,
      vitalId: json['vitalId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      normalValue: json['normalValue'] as String,
      measurement: json['measurement'] as String,
      timestamp: dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'vitalId': vitalId,
      'name': name,
      'description': description,
      'normalValue': normalValue,
      'measurement': measurement,
      'timestamp': [
        timestamp.year,
        timestamp.month,
        timestamp.day,
        timestamp.hour,
        timestamp.minute,
      ],
    };
  }
}