import 'package:doni_pizza/data/database/food_database.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/models/order_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final FoodItem food;

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
  final LocalDatabase foodRepository = LocalDatabase();
  List<FoodItem> foodItems = [];
  double totalValue = 0.0;

  FoodBloc() : super(TodoInitialState()) {
    on<LoadTodosEvent>(_handleLoadTodosEvent);
    on<AddFoodEvent>(_handleAddFoodEvent);
    on<DeleteFoods>(_handleDeleteFoods);
    // on<UpdateCountEvent>(_handleUpdateCountEvent);
    on<DeleteFood>(_handleDeleteFoodEvent);
    on<IncrementCountEvent>(_handleIncrementCountEvent);
    on<DecrementCountEvent>(_handleDecrementCountEvent);
  }

  void _handleLoadTodosEvent(LoadTodosEvent event, Emitter<FoodState> emit) async {
    emit(FoodLoadingState());
    try {
      final foods = await foodRepository.fetchAllFoodItems();

      emit(FoodLoadedState(foods));
    } catch (e) {
      emit(FoodErrorState('Failed to load foods: $e'));
    }
  }

  void _handleAddFoodEvent(AddFoodEvent event, Emitter<FoodState> emit) async {
    try {
      await foodRepository.insertFood(event.food);
      final foods = await foodRepository.fetchAllFoodItems();

      emit(FoodLoadedState(foods));
    } catch (e) {
      emit(FoodErrorState('Failed to add food: $e'));
    }
  }

  /*void _handleUpdateCountEvent(UpdateCountEvent event, Emitter<FoodState> emit) async {
    try {
      final updatedFood = event.food.copyWith(count: event.newCount);
      await foodRepository.updateFoodByCount(updatedFood.description, updatedFood.count);
      final foods = await foodRepository.fetchAllFoodItems();
      foodItems = foods;

      emit(FoodLoadedState(foods));
    } catch (e) {
      emit(FoodErrorState('Failed to update food count: $e'));
    }
  }*/

  void _handleIncrementCountEvent(IncrementCountEvent event, Emitter<FoodState> emit) async {
    try {
      final OrderItem updatedFood = event.food.copyWith(quantity: event.food.quantity + 1);
      await foodRepository.updateFoodByCount(updatedFood.food.description, updatedFood.quantity);
      final foods = await foodRepository.fetchAllFoodItems();

      emit(FoodLoadedState(foods));
    } catch (e) {
      emit(FoodErrorState('Failed to increment item count: $e'));
    }
  }

  void _handleDecrementCountEvent(DecrementCountEvent event, Emitter<FoodState> emit) async {
    try {
      if (event.food.quantity > 1) {
        final OrderItem updatedFood = event.food.copyWith(quantity: event.food.quantity - 1);
        await foodRepository.updateFoodByCount(updatedFood.food.description, updatedFood.quantity);
        final foods = await foodRepository.fetchAllFoodItems();

        emit(FoodLoadedState(foods));
      }
    } catch (e) {
      emit(FoodErrorState('Failed to decrement item count: $e'));
    }
  }

  void _handleDeleteFoods(DeleteFoods event, Emitter<FoodState> emit) async {
    try {
      await foodRepository.deleteAll();
      final foods = await foodRepository.fetchAllFoodItems();
      emit(FoodLoadedState(foods));
    } catch (e) {
      emit(FoodErrorState('Failed to delete foods: $e'));
    }
  }

  void _handleDeleteFoodEvent(DeleteFood event, Emitter<FoodState> emit) async {
    try {
      final FoodItem food = event.food;

      await foodRepository.deleteFood(food.description);
      final foods = await foodRepository.fetchAllFoodItems();

      emit(FoodLoadedState(foods));
    } catch (e) {
      emit(FoodErrorState('Failed to delete food: $e'));
    }
  }
}
