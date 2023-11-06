enum OrderStatus { pending, preparing, onRoute, delivered, canceled }

enum PaymentMethod { cash, card }

extension PaymentMethodExtension on PaymentMethod {
  static PaymentMethod fromString(String method) {
    for (var value in PaymentMethod.values) {
      if (value.toString() == method) {
        return value;
      }
    }
    throw ArgumentError('Invalid PaymentMethod string: $method');
  }
}

extension OrderStatusExtension on OrderStatus {
  String get stringValue {
    return toString().split('.').last;
  }

  static OrderStatus fromString(String status) {
    for (var value in OrderStatus.values) {
      if (value.stringValue == status) {
        return value;
      }
    }
    throw ArgumentError('Invalid OrderStatus string: $status');
  }
}
