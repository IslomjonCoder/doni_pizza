import 'dart:async';

import 'package:doni_pizza/data/models/order_item.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  static final HiveDatabase _instance = HiveDatabase._privateConstructor();

  HiveDatabase._privateConstructor();

  factory HiveDatabase() {
    return _instance;
  }

  Future<void> initHive() async {
    updateDatabasePeriodically(); // Register adapter for OrderItem
  }

  void updateDatabasePeriodically() {
    const updateInterval = Duration(hours: 1); // Change the interval as needed
    Timer.periodic(updateInterval, (Timer t) {
      updateHiveDatabase(); // Call your update function here
    });
  }

  updateHiveDatabase() async {
    final box = await openOrderItemBox();
    box.clear();
  }

  Future<Box<OrderItem>> openOrderItemBox() async {
    await initHive();
    return Hive.box<OrderItem>('orderItems');
  }

  Future<void> addOrderItem(OrderItem orderItem) async {
    final box = await openOrderItemBox();
    if (box.values.contains(orderItem)) {
      updateOrderItem(orderItem.copyWith(quantity: orderItem.quantity + 1));
      return;
    }
    await box.add(orderItem);
  }

  Future<List<OrderItem>> getAllOrderItems() async {
    final box = await openOrderItemBox();
    return box.values.toList();
  }

  Future<void> updateOrderItem(OrderItem orderItem) async {
    final box = await openOrderItemBox();
    await box.add(orderItem);
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
