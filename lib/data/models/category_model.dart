import 'package:doni_pizza/utils/helpers/uid.dart';

class CategoryModel {
  final String? id;
  final String name;
  final String imageUrl;

  CategoryModel({this.id, required this.name, required this.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? UidGenerator.generateUID(),
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
