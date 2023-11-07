import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doni_pizza/data/models/order_model.dart';
import 'package:doni_pizza/utils/constants/enums.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _ordersCollection = 'orders'; // New collection name

  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection(_ordersCollection).doc(order.id).set(order.toJson());
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Stream<List<OrderModel>> getOrderStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<OrderModel> getOrder(String orderId) async {
    try {
      final snapshot = await _firestore.collection('orders').doc(orderId).get();
      if (snapshot.exists) {
        return OrderModel.fromJson(snapshot.data()!);
      }
      throw Exception('Order not found');
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  Future<List<OrderModel>> getOrdersForUser(String userId) async {
    try {
      final querySnapshot =
          await _firestore.collection('orders').where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await _firestore.collection(_ordersCollection).doc(order.id).update(order.toJson());
    } catch (e) {
      throw Exception('Error updating order: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).delete();
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }

  /// Change the status of an order with the provided [orderId].
  /// The [newStatus] parameter specifies the new status to set.
  Future<void> changeOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _firestore.collection(_ordersCollection).doc(orderId).update({
        'status': newStatus.stringValue, // Convert enum to string using the extension
      });
    } catch (e) {
      throw Exception('Error changing order status: $e');
    }
  }
}
