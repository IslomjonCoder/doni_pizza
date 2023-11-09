import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doni_pizza/data/models/promotion_model.dart';

class PromotionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'promotions';

  // Add a new promotion to Firestore.
  Future<void> addPromotion(Promotion promotion) async {
    try {
      await _firestore.collection(_collectionName).doc(promotion.id).set({
        'id': promotion.id,
        'imageUrl': promotion.imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to add promotion: $e');
    }
  }

  Stream<List<Promotion>> getPromotionStream() {
    return _firestore.collection(_collectionName).snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Promotion.fromJson(data);

      }).toList();
    });
  }

  // Retrieve a list of all promotions from Firestore.
  Future<List<Promotion>> getAllPromotions() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Promotion(
            id: data['id'],
            imageUrl: data['imageUrl'],
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch promotions: $e');
    }
  }

  // Update an existing promotion in Firestore.
  Future<void> updatePromotion(Promotion promotion) async {
    try {
      final queries =
          await _firestore.collection(_collectionName).where('id', isEqualTo: promotion.id).get();
      if (queries.docs.isNotEmpty) {
        await queries.docs.first.reference.update({
          'imageUrl': promotion.imageUrl,
        });
      }
    } catch (e) {
      throw Exception('Failed to update promotion: $e');
    }
  }

  // Delete a specific promotion from Firestore using its ID.
  Future<void> deletePromotion(String promotionId) async {
    try {
      await _firestore.collection(_collectionName).doc(promotionId).delete();
    } catch (e) {
      throw Exception('Failed to delete promotion: $e');
    }
  }
}
