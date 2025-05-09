class FeaturedDoctor {
  final int id;
  final String fullName;
  final String pictureUrl;
  final String specialization;
  final String? coordinates;

  FeaturedDoctor({
    required this.id,
    required this.fullName,
    required this.pictureUrl,
    required this.specialization,
    this.coordinates,
  });

  factory FeaturedDoctor.fromJson(Map<String, dynamic> json) {
    return FeaturedDoctor(
      id: json['id'],
      fullName: json['fullName'],
      pictureUrl: json['pictureUrl'],
      specialization: json['specialization'],
      coordinates: json['coordinates'],
    );
  }

  @override
  String toString() {
    return 'FeaturedDoctor{id: $id, fullName: $fullName, pictureUrl: $pictureUrl, specialization: $specialization, coordinates: $coordinates}';
  }
}