import 'dart:developer'; // Import for log

class TestDetails {
  final int testId;
  final String name;
  final String type;
  final String description;
  final String? normalValues; // This should be 'norma' based on your JSON
  final String? image;

  TestDetails({
    required this.testId,
    required this.name,
    required this.type,
    required this.description,
    this.normalValues,
    this.image,
  });

  factory TestDetails.fromJson(Map<String, dynamic> json) {
    log('TestDetails.fromJson received JSON: $json');

    // Check parsing of testId
    log('Attempting to parse testId. Value in JSON: ${json['testId']}');
    final int parsedTestId = json['testId'] as int? ?? -1;
    log('Parsed testId: $parsedTestId');

    // Ensure 'norma' is used here
    final String? parsedNormalValues = json['norma'] as String?;
    log('Parsed normalValues (from "norma"): $parsedNormalValues');


    return TestDetails(
      testId: parsedTestId,
      name: json['name'] as String? ?? 'N/A',
      type: json['type'] as String? ?? 'N/A',
      description: json['description'] as String? ?? 'N/A',
      normalValues: parsedNormalValues,
      image: json['image'] as String?,
    );
  }
}