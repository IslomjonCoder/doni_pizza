part of 'food_bloc.dart';

abstract class FoodStateRemote extends Equatable {
  const FoodStateRemote();

  @override
  List<Object> get props => [];
}

class FoodInitial extends FoodStateRemote {
  @override
  List<Object> get props => [];
}

class FetchFoodLoading extends FoodStateRemote {}

class FetchFoodSuccess extends FoodStateRemote {
  final List<FoodItem> food;

  const FetchFoodSuccess(this.food);

  @override
  List<Object> get props => [food];
}

class FetchFoodFailure extends FoodStateRemote {
  final String message;

  const FetchFoodFailure(this.message);

  @override
  List<Object> get props => [message];
}
