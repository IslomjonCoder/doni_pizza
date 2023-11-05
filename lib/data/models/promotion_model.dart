class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  Promotion copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return Promotion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Promotion.fromJson(Map<String, dynamic> map) {
    return Promotion(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
