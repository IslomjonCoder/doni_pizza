import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doni_pizza/data/models/food_model.dart';

class FoodItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _foodItemsCollection = 'food_items';

  /// Retrieves a list of all food items from the Firestore collection.
  Future<List<FoodItem>> getAllFoodItems() async {
    final querySnapshot = await _firestore.collection(_foodItemsCollection).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        return FoodItem.fromJson(doc.data());
      }).toList();
    } else {
      throw Exception('No food items found.');
    }
  }

  Stream<List<FoodItem>> getFoodsStream() {
    return _firestore.collection(_foodItemsCollection).snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return FoodItem.fromJson(doc.data());
      }).toList();
    });
  }

  /// Retrieves a list of food items in a specific category based on the provided [categoryId].
  Future<List<FoodItem>> getFoodItemsInCategory(String categoryId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_foodItemsCollection)
          .where('category.id', isEqualTo: categoryId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          return FoodItem.fromJson(doc.data());
        }).toList();
      } else {
        throw Exception('No food items found in the category.');
      }
    } catch (e) {
      throw Exception('Error fetching food items in category: $e');
    }
  }

  /// Searches for food items based on a [query] string, filtering by name.
  Future<List<FoodItem>> searchFoodItems(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_foodItemsCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: "$query\uf8ff")
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          return FoodItem.fromJson(doc.data());
        }).toList();
      } else {
        throw Exception('No matching food items found.');
      }
    } catch (e) {
      throw Exception('Error searching for food items: $e');
    }
  }

  /// Adds a new food item to the Firestore collection.
  Future<void> addFoodItem(FoodItem foodItem) async {
    try {
      await _firestore.collection(_foodItemsCollection).doc(foodItem.id).set(foodItem.toJson());
    } catch (e) {
      throw Exception('Error adding food item: $e');
    }
  }

  /// Updates an existing food item in the Firestore collection based on its [foodItemId].
  Future<void> updateFoodItem(String foodItemId, FoodItem foodItem) async {
    try {
      await _firestore.collection(_foodItemsCollection).doc(foodItemId).update(foodItem.toJson());
    } catch (e) {
      throw Exception('Error updating food item: $e');
    }
  }

  /// Deletes a specific food item from the Firestore collection using its unique [foodItemId].
  Future<void> deleteFoodItem(String foodItemId) async {
    try {
      await _firestore.collection(_foodItemsCollection).doc(foodItemId).delete();
    } catch (e) {
      throw Exception('Error deleting food item: $e');
    }
  }
}
