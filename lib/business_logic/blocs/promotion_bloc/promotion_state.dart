part of 'promotion_bloc.dart';

abstract class PromotionState {}

class PromotionInitial extends PromotionState {}

class PromotionLoading extends PromotionState {}

class PromotionLoaded extends PromotionState {
  final List<Promotion> promotions;

  PromotionLoaded(this.promotions);
}

class PromotionError extends PromotionState {
  final String error;

  PromotionError(this.error);
}
