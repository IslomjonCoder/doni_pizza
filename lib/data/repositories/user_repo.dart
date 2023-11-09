import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doni_pizza/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeUserData(UserModel user) async {
    try {
      // Use the user's ID as the document ID when storing user data
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      throw Exception('Error storing user data: $e');
    }
  }

  Future<UserModel> updateUserData(String name, String phoneNumber) async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'name': name, 'phoneNumber': phoneNumber});
      final user =
          await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      return UserModel.fromJson(user);
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }

  Future<UserModel?> getUserInfo() async {
    try {
      final user =
          await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      return UserModel.fromJson(user);
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

// You can add methods for fetching user data, updating user data, and more as needed.
}
