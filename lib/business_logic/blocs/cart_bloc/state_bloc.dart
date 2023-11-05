import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
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
  DeleteFoods();
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
  final Box<OrderItem> foodBox = Hive.box<OrderItem>('orderItems');

  @override
  FoodBloc() : super(TodoInitialState()) {
    on<LoadTodosEvent>(_handleLoadTodosEvent);
    on<AddFoodEvent>(_handleAddFoodEvent);
    on<DeleteFoods>(_handleDeleteFoods);
    on<DeleteFood>(_handleDeleteFoodEvent);
    on<IncrementCountEvent>(_handleIncrementCountEvent);
    on<DecrementCountEvent>(_handleDecrementCountEvent);
  }

  void _handleLoadTodosEvent(LoadTodosEvent event, Emitter<FoodState> emit) {
    emit(FoodLoadedState(foodBox.values.toList()));
  }

  void _handleAddFoodEvent(AddFoodEvent event, Emitter<FoodState> emit) {
    try {
      foodBox.add(OrderItem(food: event.food, quantity: 1));
      emit(FoodLoadedState(foodBox.values.toList()));
    } catch (e) {
      emit(FoodErrorState('Failed to add food: $e'));
    }
  }

  void _handleIncrementCountEvent(IncrementCountEvent event, Emitter<FoodState> emit) {
    try {
      final int index = foodBox.values
          .toList()
          .indexWhere((orderItem) => orderItem.food.id == event.food.food.id);

      if (index >= 0) {
        final OrderItem updatedFood =
            foodBox.getAt(index)!.copyWith(quantity: event.food.quantity + 1);
        foodBox.putAt(index, updatedFood);
        emit(FoodLoadedState(foodBox.values.toList()));
      }
    } catch (e) {
      emit(FoodErrorState('Failed to increment item count: $e'));
    }
  }

  void _handleDecrementCountEvent(DecrementCountEvent event, Emitter<FoodState> emit) {
    try {
      final int index = foodBox.values
          .toList()
          .indexWhere((orderItem) => orderItem.food.id == event.food.food.id);

      if (index >= 0 && event.food.quantity > 1) {
        final OrderItem updatedFood =
            foodBox.getAt(index)!.copyWith(quantity: event.food.quantity - 1);
        foodBox.putAt(index, updatedFood);
        emit(FoodLoadedState(foodBox.values.toList()));
      }
    } catch (e) {
      emit(FoodErrorState('Failed to decrement item count: $e'));
    }
  }

  void _handleDeleteFoods(DeleteFoods event, Emitter<FoodState> emit) {
    try {
      foodBox.clear();
      print('ok');
      emit(FoodLoadedState(foodBox.values.toList()));
    } catch (e) {
      emit(FoodErrorState('Failed to delete foods: $e'));
    }
  }

  void _handleDeleteFoodEvent(DeleteFood event, Emitter<FoodState> emit) {
    try {
      final int index = foodBox.values
          .toList()
          .indexWhere((orderItem) => orderItem.food.id == event.food.food.id);

      if (index >= 0) {
        foodBox.deleteAt(index);
        emit(FoodLoadedState(foodBox.values.toList()));
      }
    } catch (e) {
      emit(FoodErrorState('Failed to delete food: $e'));
    }
  }
}
