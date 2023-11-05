import 'package:doni_pizza/data/models/order_item.dart';
import 'package:doni_pizza/utils/constants/enums.dart';
import 'package:doni_pizza/utils/helpers/time_heplers.dart';
import 'package:doni_pizza/utils/helpers/uid.dart';

class OrderModel {
  final String? id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final OrderStatus status;
  final DateTime timestamp;

  const OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.timestamp,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson = json['items'];
    List<OrderItem> items = itemsJson.map((itemJson) => OrderItem.fromJson(itemJson)).toList();

    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      items: items,
      totalPrice: json['totalPrice'].toDouble(),
      status: OrderStatusExtension.fromString(json['status']),
      timestamp: TTimeHelpers.timestampToDateTime(json['timestamp'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? UidGenerator.generateUID(),
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'status': status.stringValue,
      'timestamp': TTimeHelpers.dateTimeToTimestamp(timestamp),
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? totalPrice,
    OrderStatus? status,
    DateTime? timestamp,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}