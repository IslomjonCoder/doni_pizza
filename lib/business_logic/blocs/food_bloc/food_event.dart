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

class CreateFoodItem extends FoodEvent {
  final FoodItem foodItem;
  final File image;

  const CreateFoodItem(this.foodItem, this.image);

  @override
  List<Object> get props => [foodItem, image];
}

class UpdateFoodItem extends FoodEvent {
  final String foodItemId;
  final FoodItem updatedFoodItem;
  final File image;

  const UpdateFoodItem(this.foodItemId, this.updatedFoodItem, this.image);

  @override
  List<Object> get props => [foodItemId, updatedFoodItem, image];
// @override
// List<Object?> get props => [foodItemId, updatedFoodItem];
}

class DeleteFoodItem extends FoodEvent {
  final String foodItemId;

  const DeleteFoodItem(this.foodItemId);

  @override
  List<Object> get props => [foodItemId];
}
