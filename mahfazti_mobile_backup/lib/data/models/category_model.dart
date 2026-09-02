import '../../domain/entities/category.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? icon;
  final String? color;
  final bool isDefault;

  const CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    required this.isDefault,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isDefault: json['isDefault'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'isDefault': isDefault,
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      icon: icon,
      color: color,
      isDefault: isDefault,
    );
  }
}
