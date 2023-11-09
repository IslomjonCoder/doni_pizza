class Promotion {
  final String id;
  final String imageUrl;

  Promotion({
    required this.id,
    required this.imageUrl,
  });

  Promotion copyWith({
    String? id,
    String? imageUrl,
  }) {
    return Promotion(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  factory Promotion.fromJson(Map<String, dynamic> map) {
    return Promotion(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
