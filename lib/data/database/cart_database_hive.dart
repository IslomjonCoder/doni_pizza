import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/models/order_item.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartHiveDatabase {
  static final CartHiveDatabase _instance = CartHiveDatabase._privateConstructor();

  CartHiveDatabase._privateConstructor();

  factory CartHiveDatabase() {
    return _instance;
  }

  Future<void> initHive() async {}

  // Add methods to perform operations for each event type

  Future<void> addOrderItem(FoodItem orderItem) async {
    print('add event');
    final box = await Hive.openBox<OrderItem>('orderItems');
    if( box.containsKey(orderItem.id)){
      final OrderItem? currentOrderItem = box.get(orderItem.id);
      box.put(orderItem.id, currentOrderItem!.copyWith(quantity: currentOrderItem.quantity + 1));
    }
    else{
      await box.put(orderItem.id, OrderItem(food: orderItem, quantity: 1));
    }

  }

  Future<void> increaseOrderItemQuantity(OrderItem orderItem) async {
    final box = await Hive.openBox<OrderItem>('orderItems');
    final index = box.values.toList();
    final updatedOrderItem = orderItem.copyWith(quantity: orderItem.quantity + 1);
    await box.put(orderItem.food.id, updatedOrderItem);
  }

  Future<void> decreaseOrderItemQuantity(OrderItem orderItem) async {
    final box = await Hive.openBox<OrderItem>('orderItems');
    final index = box.values.toList();
    print('ok');
    if (orderItem.quantity == 1) {
      print('ok2');
      await box.delete(orderItem.food.id);
      return;
    }
    print('ok1');
    final updatedOrderItem = orderItem.copyWith(quantity: orderItem.quantity - 1);
    await box.put(orderItem.food.id, updatedOrderItem);
  }

  Future<List<OrderItem>> getAllOrderItems() async {
    final box = await Hive.openBox<OrderItem>('orderItems');
    return box.values.toList();
  }

  // Add more methods for update, delete, and other operations as needed
  deleteOrderItem(OrderItem orderItem) async {
    final box = await Hive.openBox<OrderItem>('orderItems');
    await box.delete(orderItem.food.id);
  }

  Future<void> clearAllBoxes() async {
    await Hive.deleteBoxFromDisk('foodItems');
    await Hive.deleteBoxFromDisk('orderItems');
  }

  clearAllFoodIctems() async {
    final box = await Hive.openBox<FoodItem>('foodItems');
    await box.clear();
  }
}
