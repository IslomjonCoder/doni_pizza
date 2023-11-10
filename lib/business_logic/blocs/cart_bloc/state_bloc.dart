
import 'package:doni_pizza/data/database/cart_database_hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/models/order_item.dart';

// Events
abstract class FoodEvent {}

class LoadTodosEvent extends FoodEvent {}

class AddFoodEvent extends FoodEvent {
  final FoodItem food;

  AddFoodEvent(this.food);
}

class UpdateFoodEvent extends FoodEvent {
  final FoodItem food;

  UpdateFoodEvent(this.food);
}

class DeleteFoods extends FoodEvent {
  final OrderItem food;

  DeleteFoods(this.food);
}

class DeleteFood extends FoodEvent {
  final OrderItem food;

  DeleteFood(this.food);
}

class UpdateCountEvent extends FoodEvent {
  final FoodItem food;
  final int newCount;

  UpdateCountEvent(this.food, this.newCount);
}

class IncrementCountEvent extends FoodEvent {
  final OrderItem food;

  IncrementCountEvent(this.food);
}

class DecrementCountEvent extends FoodEvent {
  final OrderItem food;

  DecrementCountEvent(this.food);
}

class ClearCartEvent extends FoodEvent {
  ClearCartEvent();
}

// States
abstract class FoodState {}

class TodoInitialState extends FoodState {}

class FoodLoadingState extends FoodState {}

class FoodLoadedState extends FoodState {
  final List<OrderItem> foods;

  double get totalValue =>
      foods.fold(0, (previousValue, element) => (element.totalPrice) + previousValue);

  FoodLoadedState(this.foods);
}

class FoodErrorState extends FoodState {
  final String errorMessage;

  FoodErrorState(this.errorMessage);
}

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final CartHiveDatabase hiveDatabase = CartHiveDatabase();

  @override
  FoodBloc() : super(TodoInitialState()) {
    on<LoadTodosEvent>(_handleLoadTodosEvent);
    on<AddFoodEvent>(_handleAddFoodEvent);
    on<DeleteFoods>(_handleDeleteFoods);
    on<DeleteFood>(_handleDeleteFood);
    on<IncrementCountEvent>(_handleIncrementCountEvent);
    on<DecrementCountEvent>(_handleDecrementCountEvent);
    on<ClearCartEvent>(_handleClearCartEvent);
  }

  void _handleLoadTodosEvent(LoadTodosEvent event, Emitter<FoodState> emit) async {
    try {
      // Retrieve food items from Hive and emit the success state
      final orderItems = await hiveDatabase.getAllOrderItems();
      emit(FoodLoadedState(orderItems));
    } catch (e) {
      emit(FoodErrorState('Failed to load food items'));
    }
  }

  Future<void> _handleAddFoodEvent(AddFoodEvent event, Emitter<FoodState> emit) async {
    try {
      // Add the food item to Hive
      await hiveDatabase.addOrderItem(event.food);
      final orderItems = await hiveDatabase.getAllOrderItems();
      emit(FoodLoadedState(orderItems));
    } catch (e) {
      emit(FoodErrorState('Failed to add food item'));
    }
  }

  Future<void> _handleDeleteFoods(DeleteFoods event, Emitter<FoodState> emit) async {
    try {
      // Clear the cart in Hive (delete all food items)
      await hiveDatabase.clearAllFoodItems();
      final orderItems = await hiveDatabase.getAllOrderItems();
      emit(FoodLoadedState(orderItems));
    } catch (e) {
      // emit(FoodErrorState('Failed to clear cart'));
    }
  }

  Future<void> _handleIncrementCountEvent(
      IncrementCountEvent event, Emitter<FoodState> emit) async {
    try {
      // Handle increment logic and update the count in CartHiveDatabase
      // Example: await hiveDatabase.incrementFoodItemCount(event.food.key);
      await hiveDatabase.increaseOrderItemQuantity(event.food);
      final orderItems = await hiveDatabase.getAllOrderItems();
      emit(FoodLoadedState(orderItems));
    } catch (e) {
      emit(FoodErrorState('Failed to increment count'));
    }
  }

  Future<void> _handleDeleteFood(DeleteFood event, Emitter<FoodState> emit) async {
    try {
      await hiveDatabase.deleteOrderItem(event.food);
      final orderItems = await hiveDatabase.getAllOrderItems();
      emit(FoodLoadedState(orderItems));
    } catch (e) {
      emit(FoodErrorState('Failed to delete food item'));
    }
  }

  Future<void> _handleDecrementCountEvent(
      DecrementCountEvent event, Emitter<FoodState> emit) async {
    try {
      // Handle decrement logic and update the count in CartHiveDatabase
      // Example: await hiveDatabase.decrementFoodItemCount(event.food.key);
      await hiveDatabase.decreaseOrderItemQuantity(event.food);
      final orderItems = await hiveDatabase.getAllOrderItems();
      emit(FoodLoadedState(orderItems));
    } catch (e) {
      emit(FoodErrorState('Failed to decrement count'));
    }
  }

  Future<void> _handleClearCartEvent(ClearCartEvent event, Emitter<FoodState> emit) async {
    try {
      // Clear the cart in Hive (delete all food items)
      await hiveDatabase.clearAllFoodItems();
      emit(FoodLoadedState([]));
    } catch (e) {
      emit(FoodErrorState('Failed to clear cart'));
    }
  }
}
