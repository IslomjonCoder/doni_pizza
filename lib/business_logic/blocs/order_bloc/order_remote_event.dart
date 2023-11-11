part of 'order_remote_bloc.dart';

abstract class OrderRemoteEvent {}

class CreateOrderEvent extends OrderRemoteEvent {
  final OrderModel order;

  CreateOrderEvent(this.order);
}

// class FetchOrdersEvent extends OrderRemoteEvent {
//   final String userId;
//
//   FetchOrdersEvent(this.userId);
// }

// class UpdateOrderEvent extends OrderRemoteEvent {
//   final OrderModel order;
//
//   UpdateOrderEvent(this.order);
// }

// class DeleteOrderEvent extends OrderRemoteEvent {
//   final String orderId;
//
//   DeleteOrderEvent(this.orderId);
// }

// class ChangeOrderStatusEvent extends OrderRemoteEvent {
//   final String orderId;
//   final OrderStatus newStatus;
//
//   ChangeOrderStatusEvent(this.orderId, this.newStatus);
// }
class UpdateOrdersEvent extends OrderRemoteEvent {
  final List<OrderModel> orders;
  UpdateOrdersEvent(this.orders);
}