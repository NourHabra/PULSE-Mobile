class PharmacyModel {
  final int id;
  final String name;
  final String address;
  final String? pictureUrl;
  // Add other relevant pharmacy fields

  PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    this.pictureUrl,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
    );
  }
}
