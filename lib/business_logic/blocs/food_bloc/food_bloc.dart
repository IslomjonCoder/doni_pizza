import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/repositories/food_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

part 'food_event.dart';

part 'food_state.dart';

class FoodBlocRemote extends Bloc<FoodEvent, FoodStateRemote> {
  final FoodItemRepository foodRepository;

  FoodBlocRemote(this.foodRepository) : super(FoodInitial()) {
    on<GetAll>(_fetchFoodItems);
    on<GetFoodsByCategory>(_fetchFoodItemsByCategory);
    on<SearchFoodItem>(
      _searchFoodItems,
      transformer: restartable(),
    );
  }

  _fetchFoodItems(GetAll event, Emitter<FoodStateRemote> emit) async {
    emit(FetchFoodLoading());
    try {
      final foods = await foodRepository.getAllFoodItems();
      emit(FetchFoodSuccess(foods));
    } catch (e) {
      emit(FetchFoodFailure('Failed to fetch food items: $e'));
    }
  }

  _fetchFoodItemsByCategory(GetFoodsByCategory event, Emitter<FoodStateRemote> emit) async {
    emit(FetchFoodLoading());
    try {
      final foods = await foodRepository.getFoodItemsInCategory(event.categoryId);
      emit(FetchFoodSuccess(foods));
    } catch (e) {
      emit(FetchFoodFailure('Failed to fetch food items: $e'));
    }
  }

  _searchFoodItems(SearchFoodItem event, Emitter<FoodStateRemote> emit) async {
    print("searching for ${event.query}");
    emit(FetchFoodLoading());
    try {
      final foods = await foodRepository.searchFoodItems(event.query);
      emit(FetchFoodSuccess(foods));
    } catch (e) {
      emit(FetchFoodFailure('Failed to fetch food items: $e'));
    }
  }
}
