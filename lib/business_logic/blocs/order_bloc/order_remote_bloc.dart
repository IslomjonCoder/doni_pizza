import 'dart:async';
import 'package:doni_pizza/data/models/order_model.dart';
import 'package:doni_pizza/data/repositories/order_repo.dart';
import 'package:doni_pizza/utils/constants/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_remote_event.dart';

part 'order_remote_state.dart';

class OrderRemoteBloc extends Bloc<OrderRemoteEvent, OrderRemoteState> {
  final OrderRepository orderRepository = OrderRepository();

  OrderRemoteBloc() : super(OrderRemoteInitial()) {
    on<CreateOrderEvent>(createOrderEventToState);
    on<FetchOrdersEvent>(fetchOrdersEventToState);
    on<UpdateOrderEvent>(updateOrderEventToState);
    on<DeleteOrderEvent>(deleteOrderEventToState);
    on<ChangeOrderStatusEvent>(changeOrderStatusEventToState);
  }

  void createOrderEventToState(CreateOrderEvent event, Emitter<OrderRemoteState> emit) async {
    emit(OrderRemoteLoading());
    try {
      await orderRepository.createOrder(event.order);
      emit(OrderCreatedState(event.order));
    } catch (e) {
      emit(OrderRemoteErrorState('Error creating order: $e'));
    }
  }

  void fetchOrdersEventToState(FetchOrdersEvent event, Emitter<OrderRemoteState> emit) async {
    emit(OrderRemoteLoading());
    try {
      final orders = await orderRepository.getOrdersForUser(event.userId);
      emit(OrdersFetchedState(orders));
    } catch (e) {
      emit(OrderRemoteErrorState('Error fetching orders: $e'));
    }
  }

  void updateOrderEventToState(UpdateOrderEvent event, Emitter<OrderRemoteState> emit) async {
    emit(OrderRemoteLoading());
    try {
      await orderRepository.updateOrder(event.order);
      emit(OrderUpdatedState(event.order));
    } catch (e) {
      emit(OrderRemoteErrorState('Error updating order: $e'));
    }
  }

  void deleteOrderEventToState(DeleteOrderEvent event, Emitter<OrderRemoteState> emit) async {
    emit(OrderRemoteLoading());
    try {
      await orderRepository.deleteOrder(event.orderId);
      emit(OrderDeletedState(event.orderId));
    } catch (e) {
      emit(OrderRemoteErrorState('Error deleting order: $e'));
    }
  }

  void changeOrderStatusEventToState(
      ChangeOrderStatusEvent event, Emitter<OrderRemoteState> emit) async {
    try {
      await orderRepository.changeOrderStatus(event.orderId, event.newStatus);
      emit(OrderStatusChangedState());
    } catch (e) {
      emit(OrderRemoteErrorState('Error changing order status: $e'));
    }
  }
}
