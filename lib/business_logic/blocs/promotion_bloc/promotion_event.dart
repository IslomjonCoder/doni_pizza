part of 'promotion_bloc.dart';

abstract class PromotionEvent {}

class AddPromotion extends PromotionEvent {
  final Promotion promotion;
  final File image;

  AddPromotion(this.promotion, this.image);
}

class GetAllPromotions extends PromotionEvent {}

class UpdatePromotion extends PromotionEvent {
  final Promotion promotion;
  final File image;
  UpdatePromotion(this.promotion, this.image);
}

class DeletePromotion extends PromotionEvent {
  final String promotionId;

  DeletePromotion(this.promotionId);
}
