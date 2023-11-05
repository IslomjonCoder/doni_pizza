import 'package:doni_pizza/data/models/order_item.dart';
import 'package:hive/hive.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  static final HiveDatabase _instance = HiveDatabase._privateConstructor();

  HiveDatabase._privateConstructor();

  factory HiveDatabase() {
    return _instance;
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FoodItemAdapter()); // Register adapter for FoodItem
    Hive.registerAdapter(OrderItemAdapter()); // Register adapter for OrderItem
  }

  Future<Box<OrderItem>> openOrderItemBox() async {
    await initHive();
    return await Hive.openBox<OrderItem>('orderItems');
  }

  Future<void> addOrderItem(OrderItem orderItem) async {
    final box = await openOrderItemBox();
    await box.add(orderItem);
  }

  Future<List<OrderItem>> getAllOrderItems() async {
    final box = await openOrderItemBox();
    return box.values.toList();
  }

  Future<void> updateOrderItem(OrderItem orderItem) async {
    final box = await openOrderItemBox();
    await box.put(orderItem.key, orderItem);
  }

  Future<void> deleteOrderItem(int key) async {
    final box = await openOrderItemBox();
    await box.delete(key);
  }

  Future<void> clearAllOrderItems() async {
    final box = await openOrderItemBox();
    await box.clear();
  }
}
