part of 'food_bloc.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

class GetAll extends FoodEvent {}

class GetFoodsByCategory extends FoodEvent {
  final String categoryId;

  const GetFoodsByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SearchFoodItem extends FoodEvent {
  final String query;

  const SearchFoodItem(this.query);

  @override
  List<Object> get props => [query];
}

class UpdateFoodItems extends FoodEvent {
  final List<FoodItem> foods;

  const UpdateFoodItems(this.foods);
}
