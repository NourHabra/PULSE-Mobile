// lib/models/categoryModel.dart
class Category {
  final int id; // Add the id
  final String title;
  final String imageUrl;

  Category({required this.id, required this.title, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int? ?? 0, //  handle null
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}