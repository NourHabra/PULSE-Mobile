class LabTestModel {
  final int id;
  final String name;
  final String price;
  final String imageUrl; // Renamed from 'image' for clarity, as it holds a URL
  final String description;
  final String normalValues;
  final String type;

  LabTestModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl, // Use imageUrl here
    required this.description,
    required this.normalValues,
    required this.type,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> json) {
    // Access 'id' from the top level object
    final int testId = json['id'] as int? ?? 0;

    // Access 'name' from the nested 'test' object
    final String testName = json['test']?['name'] as String? ?? 'N/A';

    // Access 'price' from the top level object and format it
    final double? rawPrice = json['price'] as double?;
    final String formattedPrice = rawPrice != null ? '${rawPrice.toStringAsFixed(0)} SYP' : 'N/A';

    // Access 'image' from the nested 'test' object
    // Add a print statement here to see the raw value of 'image'
    final String? rawImageValue = json['test']?['image'] as String?;
    print('DEBUG: Raw image value from JSON: $rawImageValue'); // <-- Added debug print

    // If not found, fall back to a placeholder
    final String testImageUrl = rawImageValue ??
        'https://placehold.co/150x180/000000/FFFFFF?text=${testName.split(' ').first}';


    // Access 'description', 'normalValues', and 'type' from the nested 'test' object
    final String testDescription = json['test']?['description'] as String? ?? 'N/A';
    final String testNormalValues = json['test']?['normalValues'] as String? ?? 'N/A';
    final String testType = json['test']?['type'] as String? ?? 'N/A';

    return LabTestModel(
      id: testId,
      name: testName,
      price: formattedPrice,
      imageUrl: testImageUrl, // Use imageUrl here
      description: testDescription,
      normalValues: testNormalValues,
      type: testType,
    );
  }
}
