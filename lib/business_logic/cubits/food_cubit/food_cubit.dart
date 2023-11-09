import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/repositories/food_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodCubit extends Cubit<List<FoodItem>> {
  final FoodItemRepository foodItemRepository;

  FoodCubit(this.foodItemRepository) : super([]) {
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    try {
      final foods = await foodItemRepository.getAllFoodItems();
      emit(foods);
    } catch (e) {
    }
  }

  Future<void> getFoodItemsInCategory(String categoryId) async {
    try {
      final foodsByCategory = await foodItemRepository.getFoodItemsInCategory(categoryId);
      emit(foodsByCategory);
    } catch (e) {
    }
  }

  Future<void> searchFoodItems(String query) async {
    try {
      final foodsByCategory = await foodItemRepository.searchFoodItems(query);
      emit(foodsByCategory);
    } catch (e) {
    }
  }
}
