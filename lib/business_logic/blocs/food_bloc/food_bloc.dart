import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/repositories/food_repo.dart';
import 'package:doni_pizza/utils/cache/cache_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'food_event.dart';

part 'food_state.dart';

class FoodBlocRemote extends Bloc<FoodEvent, FoodStateRemote> {
  final FoodItemRepository foodRepository;
  final CacheManager cacheManager = CacheManager(); // Instantiate the CacheManager

  FoodBlocRemote(this.foodRepository) : super(FoodInitial()) {
    on<GetAll>(_fetchFoodItems);
    on<GetFoodsByCategory>(_fetchFoodItemsByCategory);
    on<SearchFoodItem>(
      _searchFoodItems,
      transformer: restartable(),
    );
    on<CreateFoodItem>(_createFoodItem);
    on<UpdateFoodItem>(_updateFoodItem);
    on<DeleteFoodItem>(_deleteFoodItem);
  }

  _fetchFoodItems(GetAll event, Emitter<FoodStateRemote> emit) async {
    emit(FetchFoodLoading());
    try {
      final cachedData = cacheManager.get('all_foods'); // Check cache for data
      if (cachedData != null) {
        // If data is found in the cache, emit it
        emit(FetchFoodSuccess(cachedData));
      }

      final foods = await foodRepository.getAllFoodItems();
      emit(FetchFoodSuccess(foods));

      // Cache the data
      cacheManager.add('all_foods', foods);
    } catch (e) {
      emit(FetchFoodFailure('Failed to fetch food items: $e'));
    }
  }

  _fetchFoodItemsByCategory(GetFoodsByCategory event, Emitter<FoodStateRemote> emit) async {
    emit(FetchFoodLoading());
    try {
      final cachedData = cacheManager.get('category_${event.categoryId}'); // Check cache for data
      if (cachedData != null) {
        // If data is found in the cache, emit it
        emit(FetchFoodSuccess(cachedData));
      }

      final foods = await foodRepository.getFoodItemsInCategory(event.categoryId);
      emit(FetchFoodSuccess(foods));

      // Cache the data
      cacheManager.add('category_${event.categoryId}', foods);
    } catch (e) {
      emit(FetchFoodFailure('Failed to fetch food items: $e'));
    }
  }

  _searchFoodItems(SearchFoodItem event, Emitter<FoodStateRemote> emit) async {
    emit(FetchFoodLoading());
    try {
      final cachedData = cacheManager.get('search_${event.query}'); // Check cache for data
      if (cachedData != null) {
        // If data is found in the cache, emit it
        emit(FetchFoodSuccess(cachedData));
      }

      final foods = await foodRepository.searchFoodItems(event.query);
      emit(FetchFoodSuccess(foods));

      // Cache the data
      cacheManager.add('search_${event.query}', foods);
    } catch (e) {
      emit(FetchFoodFailure('Failed to fetch food items: $e'));
    }
  }

  _createFoodItem(CreateFoodItem event, Emitter<FoodStateRemote> emit) async {
    // Handle creating a food item remotely
    try {
      await foodRepository.addFoodItem(event.foodItem);
      final foods = await foodRepository.getAllFoodItems();
      emit(FetchFoodSuccess(foods));
    } catch (e) {
      emit(FetchFoodFailure('Failed to create food item: $e'));
    }
  }

  _updateFoodItem(UpdateFoodItem event, Emitter<FoodStateRemote> emit) async {
    // Handle updating a food item remotely
    try {
      await foodRepository.updateFoodItem(event.foodItemId, event.updatedFoodItem);
      final foods = await foodRepository.getAllFoodItems();
      emit(FetchFoodSuccess(foods));
    } catch (e) {
      emit(FetchFoodFailure('Failed to update food item: $e'));
    }
  }

  _deleteFoodItem(DeleteFoodItem event, Emitter<FoodStateRemote> emit) async {
    // Handle deleting a food item remotely
    try {
      await foodRepository.deleteFoodItem(event.foodItemId);
      final foods = await foodRepository.getAllFoodItems();
      emit(FetchFoodSuccess(foods));
    } catch (e) {
      emit(FetchFoodFailure('Failed to delete food item: $e'));
    }
  }
}
