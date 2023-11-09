import 'package:doni_pizza/data/models/food_model.dart';
import 'package:hive/hive.dart';

part 'order_item.g.dart';

@HiveType(typeId: 0)
class OrderItem extends HiveObject {
  @HiveField(0)
  FoodItem food;

  @HiveField(1)
  int quantity;

  double get totalPrice => food.price * quantity;

  OrderItem({
    required this.food,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      food: FoodItem.fromJson(json['food']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
    };
  }

  OrderItem copyWith({
    FoodItem? food,
    int? quantity,
  }) {
    return OrderItem(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          // runtimeType == other.runtimeType &&
          food == other.food &&
          quantity == other.quantity;

  @override
  int get hashCode => food.hashCode ^ quantity.hashCode;
}
