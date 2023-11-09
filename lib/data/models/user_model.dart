import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class UserModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final String? email;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.imageUrl,
    required this.email,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? imageUrl,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'email': email,
    };
  }

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      imageUrl: map['imageUrl'] as String?,
      email: map['email'] as String?,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, phoneNumber: $phoneNumber, imageUrl: $imageUrl, email: $email}';
  }
}
