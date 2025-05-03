// Model (DoctorCategoryModel.dart)
class DoctorCategory {
  final int id;
  final String name;
  final String icon;

  DoctorCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory DoctorCategory.fromJson(Map<String, dynamic> json) {
    return DoctorCategory(
      id: json['d_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}
