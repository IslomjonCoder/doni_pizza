part of 'order_remote_bloc.dart';

abstract class OrderRemoteState {}

class OrderRemoteInitial extends OrderRemoteState {}

class OrderRemoteLoading extends OrderRemoteState {}

class OrderCreatedState extends OrderRemoteState {
  OrderCreatedState();
}
class OrderCreateSuccessState extends OrderRemoteState {
  OrderCreateSuccessState();
}
class OrdersFetchedState extends OrderRemoteState {
  final List<OrderModel> orders;

  OrdersFetchedState(this.orders);
}

class OrderUpdatedState extends OrderRemoteState {
  final OrderModel order;

  OrderUpdatedState(this.order);
}

// class OrderDeletedState extends OrderRemoteState {
//   final String orderId;
//
//   OrderDeletedState(this.orderId);
// }

class OrderStatusChangedState extends OrderRemoteState {
  // final List<OrderModel> orders;

  OrderStatusChangedState();
}

class OrderRemoteErrorState extends OrderRemoteState {
  final String error;

  OrderRemoteErrorState(this.error);
}
