// lib/models/categoryModel.dart
class Category {
  final int id;
  final String title;
  final String imageUrl;

  Category({required this.id, required this.title, required this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int? ?? 0,
      title: json['name'] as String? ?? '', // <--- ENSURE THIS IS 'name'
      imageUrl: json['url'] as String? ?? '',  // <--- ENSURE THIS IS 'url'
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, title: $title, imageUrl: $imageUrl)';
  }
}